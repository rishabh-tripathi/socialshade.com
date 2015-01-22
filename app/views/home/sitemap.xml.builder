xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
    xml.priority 1.0
  end

  xml.url do
    xml.loc how_to_url
    xml.priority 0.9
  end

  @qu.each do |q|
    xml.url do
      xml.loc answer_url(q.id)
      xml.priority 0.9
    end
  end
end	