class Entry < ApplicationRecord
  def self.create_from_scrap(details)
    new_one = create(column_equivalences(details))
    puts new_one.national_rol
  end

  def self.column_equivalences(obj)
    base = {
      national_rol: obj['Rol Nacional'],
      concession_name: obj['Nombre Concesión'],
      titular_name: obj['Nombre Titular'],
      titular_dni: obj['Rut Titular']
    }

    return base if obj['details'].blank?

    base[:detail_link] = obj['details']['link']
    base[:region] = obj['details']['Región']
    base[:province] = obj['details']['Provincia']
    base[:commune] = obj['details']['Comuna']
    base[:belogings] = obj['details']['Pertenencias']
    base[:hectares] = obj['details']['Hectáreas']
    base[:rol_situation] = obj['details']['Situación Rol']
    base[:payment] = obj['details']['Pago']
    base
  end

  def self.scrap_more_results(url, region = 1, page = 1)
    region.times.each do |reg|
      EntriesWorker.perform_async(url: url, region: reg + 1, page: page)
    end
  end

  def self.number_of_current_jobs
    require 'sidekiq/api'

    queue = Sidekiq::Queue.all
    workers = Sidekiq::Workers.new
    
    (queue.size || 0) + (workers.size || 0)
  end
end
