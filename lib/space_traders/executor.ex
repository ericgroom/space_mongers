defmodule SpaceTraders.Executor do
  use GenServer
  require Logger

  # TODO telemetry on wait time
  def init(opts) do
    {:ok, %{opts: opts, jobs: [], past_jobs: []}}
  end

  def add_job(pid, execute, cost_in_points) when is_function(execute, 0) and is_integer(cost_in_points) do
    GenServer.call(pid, {:enqueue, {execute, cost_in_points}})
  end

  def handle_call({:enqueue, {execute, cost_in_points}}, from, %{jobs: jobs} = state) do
    Logger.debug("enqueueing job from #{inspect from}")
    Process.send_after(self(), :run_job, 10) # small delay for state update to occur
    {:noreply, %{state | jobs: jobs ++ [{from, execute, cost_in_points}]}}
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

    # TODO notify sender
    if cost_in_points > points_per_interval, do: raise "cannot schedule a job this big"

    if cost_in_points + used_points < points_per_interval do
      result = exec_job.()
      GenServer.reply(from, result)
      with_completed = [{System.monotonic_time(), cost_in_points} | unexpired_past_jobs]
      Logger.debug("result sent to #{inspect from}")
      schedule_success(remaining_jobs)
      {:noreply, %{state | jobs: remaining_jobs, past_jobs: with_completed }}
    else
      Logger.debug("couldn't schedule #{inspect from}")
      schedule_failure(past_jobs, cost_in_points, time_interval)
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

  defp schedule_failure(past_jobs, cost_of_next_job, time_interval) do
    # TODO sum points
    {executed_at, _} = past_jobs
      |> Enum.sort_by(fn {executed_at, _} -> executed_at end)
      |> List.first()

    now = System.monotonic_time()
    diff_native = now - executed_at
    diff_milli = System.convert_time_unit(diff_native, :native, :millisecond)
    delay = time_interval - diff_milli
    delay_normalized = if delay >= 0, do: delay, else: 100
    Logger.debug("trying to run again in #{delay_normalized}ms")
    Process.send_after(self(), :run_job, delay_normalized)
  end
end
