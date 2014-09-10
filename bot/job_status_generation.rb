module JobStatusGeneration
  def to_status
    rep = []

    rep << "Job #{ident} (#{url}):"

    if started_by
      if note
        rep << "Started by #{started_by} (#{note})."
      else
        rep << "Started by #{started_by}."
      end
    end

    if aborted?
      rep << "Job aborted."
    elsif finished?
      rep << "Job completed."
    elsif pending?
      rep << "In queue."
    elsif in_progress?
      rep << "In progress.  Downloaded #{mb_downloaded.round(2)} MB, #{error_count.to_i} errors encountered, #{item_count} items queued."
      rep << "#{concurrency.to_i} workers, delay: [#{delay_min.to_f}, #{delay_max.to_f}] ms."
      rep << "See the ArchiveBot dashboard for more information."
    end

    if (t = ttl) && (t != -1)
      rep << "Eligible for rearchival in #{formatted_ttl(t)}."
    end

    rep
  end

  private

  def mb_downloaded
    bytes_downloaded.to_f / (1000 * 1000)
  end

  def item_count
    items_queued.to_i - items_downloaded.to_i
  end

  def formatted_ttl(ttl)
    hr = ttl / 3600
    min = (ttl % 3600) / 60
    sec = (ttl % 3600) % 60

    "#{hr}h #{min}m #{sec}s"
  end
end
