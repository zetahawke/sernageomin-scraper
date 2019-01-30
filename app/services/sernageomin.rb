class Sernageomin
  require 'open-uri'
  require 'nokogiri'
  require 'json'

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
    initial_keys = rows[0].cells.map { |cell| cell.text }
    base_obj = new_base_obj(initial_keys)

    rows[1..(rows.size - 1)].each do |tr|
      
      
      base_obj = new_base_obj(initial_keys)
    end

    save_details(row_details) unless Entry.find_by(concession_name: '')
  end

  def save_details(details)
    Entry.create(row_to_json(details))
  end

  def row_to_json(row)
    row.to_s.to_json
  end

  def new_base_obj(keys)
    base = {}
    keys.each do { |key| base[key] = '' }
    base
  end
end
