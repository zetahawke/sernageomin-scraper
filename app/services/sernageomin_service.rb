class SernageominService
  require 'open-uri'
  require 'nokogiri'

  REGIONS = (1..15)

  def initialize(url_to_scrap)
    @url = url_to_scrap
    @current_page = ''
  end

  def scrap
    for region in REGIONS
      open_page(region)
    end
  end

  def open_region(region_number)
    page = 1
    last_row_data = ''
    while last_row_data != end_of_table(open_page(region_number, page))
      open_rows
    end
  end

  def open_page(region_number, page_number)
    html = open("#{url}?pagina=#{page_number}&accion=consulta&region=#{region_number}")
    @page = Nokogiri::HTML(html)
  end

  def end_of_table(doc)
    ''
  end

  def open_rows
    table = @page.at('table')
    rows = table.search('tr')
    initial_keys = rows[0].cells.map { |cell| cell.try(:text).try(:strip) }
    base_obj = new_base_obj(initial_keys)

    rows[1..(rows.size - 1)].each do |tr|
      base_obj = populate_obj(base_obj, tr)
      save_details(base_obj) #unless Entry.find_by(concession_name: '')
      base_obj = new_base_obj(initial_keys)
    end
  end

  def save_details(details)
    Entry.create_from_scrap(row_to_json(details))
  end

  def row_to_json(row)
    row.to_s.to_json
  end

  def new_base_obj(keys)
    base = {}
    keys.each do { |key| base[key] = '' }
    base
  end

  def populate_obj(obj, row)
    obj.keys.each_with_index do |key, index|
      if key.to_s.downcase.include?('detalle')
        obj['details'] = bring_details(row.cells[index])
      else
        obj[key] = row.cells[index].try(:text).try(:strip)
      end
    end
    obj
  end

  def bring_details(cell)
    links = cell.css('a')
    return if links.blank?

    html = open(links.first)
    doc = Nokogiri::HTML(html)
    obj = object_from_table(doc)
    obj['link'] = links.first
    obj
  end

  def object_from_table(doc)
    table = @page.at('table')
    rows = table.search('tr')

    obj = {}
    rows.each do |row|
      key = row.cells[0].css('label').first.try(:text).try(:strip)
      value = row.cells[1].css('input').first['value']
      obj[key] = value
    end
    obj
  end
end
