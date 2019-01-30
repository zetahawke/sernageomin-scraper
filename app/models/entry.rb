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
end
