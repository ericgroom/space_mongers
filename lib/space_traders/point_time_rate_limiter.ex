defmodule SpaceTraders.PointTimeRateLimiter do
  use GenServer
  require Logger

  # TODO telemetry on wait time
  def init(opts) do
    Logger.debug("PointTimeRateLimiter init")
    {:ok, %{opts: opts, jobs: [], past_jobs: []}}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def add_job(execute, cost_in_points) when is_function(execute, 0) and is_integer(cost_in_points) do
    GenServer.call(__MODULE__, {:enqueue, {execute, cost_in_points}})
  end

  def handle_call({:enqueue, {execute, cost_in_points}}, from, %{jobs: jobs, opts: opts} = state) do
    points_per_interval = opts[:points_per_interval] || 10.0

    if cost_in_points > points_per_interval do
      {:reply, {:error, "Job is greater than the maximum number of points available"}, state}
    else
      Logger.debug("enqueueing job from #{inspect from}")
      Process.send_after(self(), :run_job, 10) # small delay for state update to occur
      {:noreply, %{state | jobs: jobs ++ [{from, execute, cost_in_points}]}}
    end
  end

  def handle_info(:run_job, %{jobs: [next_job | remaining_jobs], past_jobs: past_jobs, opts: opts} = state) do
    Logger.debug("run job pass")
    time_interval = opts[:time_interval] || 1000.0
    points_per_interval = opts[:points_per_interval] || 10.0

    unexpired_past_jobs = without_expired(past_jobs, time_interval)
    used_points = unexpired_past_jobs
      |> Enum.map(fn {_, points} -> points end)
      |> Enum.sum()

    {from, exec_job, cost_in_points} = next_job
    Logger.debug("points in use: #{used_points}, trying to run for #{inspect from} with cost of #{cost_in_points}")

    if cost_in_points + used_points <= points_per_interval do
      result = exec_job.()
      GenServer.reply(from, result)
      with_completed = [{System.monotonic_time(), cost_in_points} | unexpired_past_jobs]
      Logger.debug("result sent to #{inspect from}")
      schedule_success(remaining_jobs)
      {:noreply, %{state | jobs: remaining_jobs, past_jobs: with_completed }}
    else
      Logger.debug("couldn't schedule #{inspect from}")
      schedule_failure(unexpired_past_jobs, time_interval)
      {:noreply, %{state | past_jobs: unexpired_past_jobs}}
    end
  end

  defp without_expired(past_jobs, time_interval) do
    now = System.monotonic_time()
    Enum.reject(past_jobs, fn {executed_at, _} ->
      diff_native = now - executed_at
      diff_milli = System.convert_time_unit(diff_native, :native, :millisecond)
      diff_milli > time_interval
    end)
  end

  defp schedule_success([]), do: :ok
  defp schedule_success([_ | _]), do: Process.send(self(), :run_job, [])

  defp schedule_failure([_|_] = past_jobs, time_interval) do
    # try to run job again after an element in past_jobs expires
    next_expiration = past_jobs
      |> Enum.map(fn {executed_at, _} -> executed_at end)
      |> Enum.min()

    now = System.monotonic_time()
    diff_native = now - next_expiration
    diff_milli = System.convert_time_unit(diff_native, :native, :millisecond)
    delay = time_interval - diff_milli
    # if delay is negative, just do some arbitrary delay, it shouldn't happen in practice
    delay_normalized = if delay >= 0, do: ceil(delay), else: 100
    Logger.debug("trying to run again in #{delay_normalized}ms")
    Process.send_after(self(), :run_job, delay_normalized)
  end
end
