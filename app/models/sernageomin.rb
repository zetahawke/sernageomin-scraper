class Sernageomin
  require 'open-uri'
  require 'nokogiri'

  REGIONS = (1..15)
  MAX_THREADS = ENV.fetch("RAILS_MAX_THREADS") { 5 }

  def initialize(url_to_scrap)
    @url = url_to_scrap
    @current_page = ''
    @current_url = ''
    @last_row = ''
    @region_on_reading = []
    @threads = []
  end

  def scrap(region = 1, page = 1)
    return if region > 15
    
    # while (!(@threads.count { |thread| thread.alive? } < MAX_THREADS))
    #   sleep(1)
    # end
    # @threads << Thread.new {
    #   puts "Embinding new thread"
    # }
    open_page(region, page)
    # sleep until @threads.count { |thread| thread.alive? } < 5
    scrap(region + 1, 1)
  rescue StandardError => e
    puts e.message
    scrap(region + 1, 1)
  end

  def open_page(region_number, page_number = 1, last_row_data = nil)
    agent = Mechanize.new
    @current_url = "#{@url}?pagina=#{page_number}&accion=consulta&region=#{region_number}"
    puts @current_url
    html = agent.get(@current_url)
    triggers_consult(html)
    
    puts end_of_table
    
    page_readed = Entry.find_by(national_rol: end_of_table)
    
    puts page_readed.blank?

    return if last_row_data == end_of_table

    readed_rows = read_rows
    last_row_data = readed_rows.last.search('th, td').first.try(:text).try(:strip)
    open_rows(readed_rows) if page_readed.blank?
    page_number += 1
    open_page(region_number, page_number, last_row_data)
    
    agent.shutdown
    Rails.cache.clear
  end

  def triggers_consult(html)
    @current_page = html.forms[0].submit
    # Nokogiri::HTML(new_html)
    table = @current_page.search('table')[1]
    rows = table.search('tr')
    @last_row = rows.last
  end

  def end_of_table
    return @last_row if @last_row.blank?

    @last_row.search('th, td').first.try(:text).try(:strip)
  end

  def read_rows
    table = @current_page.search('table')[1]
    table.search('tr')
  end
  
  def open_rows(rows = [])
    initial_keys = rows[0].search('th, td').map { |cell| cell.try(:text).try(:strip) }
    base_obj = new_base_obj(initial_keys)

    rows[1..(rows.size - 1)].each do |tr|
      base_obj = populate_obj(base_obj, tr)
      if Entry.find_by(concession_name: base_obj['Nombre Concesión'])
        puts "#{base_obj['Nombre Concesión']} already exist!"
        next
      end
      save_details(base_obj)
      base_obj = new_base_obj(initial_keys)
    end
    rows
  end

  def save_details(details)
    Entry.create_from_scrap(row_to_json(details))
  end

  def row_to_json(row)
    # row.to_s.to_json
    row
  end

  def new_base_obj(keys)
    base = {}
    keys.each { |key| base[key] = '' }
    base
  end

  def populate_obj(obj, row)
    obj.keys.each_with_index do |key, index|
      if key.to_s.downcase.include?('detalle')
        cell = row.search('th, td')[index]
        return if cell.blank?

        links = cell.at('a')
        obj['details'] = bring_details(links)
        obj['link'] = links['href']
      else
        obj[key] = row.search('th, td')[index].try(:text).try(:strip) unless key.blank?
      end
    end
    obj
  end

  def bring_details(links)
    return if links.blank?

    html = open("http://sitiohistorico.sernageomin.cl/#{links['href']}")
    doc = Nokogiri::HTML(html)
    obj = object_from_table(doc)
    # puts "http://sitiohistorico.sernageomin.cl/#{links.first['href']}"
    obj
  end

  def object_from_table(doc)
    table = doc.at('table')
    rows = table.search('tr')

    obj = {}
    rows.each do |row|
      key = row.search('th, td')[0].at('label').try(:text).try(:strip)
      value = (row.search('th, td')[1].at('input')['value'] unless row.search('th, td')[1].blank? || row.search('th, td')[1].at('input').blank?)
      obj[key] = value unless key.blank?
    end
    obj
  end
end
