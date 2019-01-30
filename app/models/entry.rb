class Entry < ApplicationRecord
  def self.create_from_scrap(details)
    create(column_equivalences(details))
  end

  def self.column_equivalences(obj)
    {
      national_rol: obj['Rol Nacional'],
      concession_name: obj['Nombre Concesión'],
      titular_name: obj['Nombre Titular'],
      titular_dni: obj['Rut Titular'],
      detail_link: obj['link'],
      region: obj['details']['Región'],
      province: obj['details']['Provincia'],
      commune: obj['details']['Comuna'],
      belogings: obj['details']['Pertenencias'],
      hectares: obj['details']['Hectáreas'],
      rol_situation: obj['details']['Situación Rol'],
      payment: obj['details']['Pago']
    }
  end
end
