xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
    xml.priority 1.0
  end

  xml.url do
    xml.loc ask_url
    xml.priority 0.9
  end

  @qu.each do |q|
    xml.url do
      xml.loc answer_url(q.id)
      xml.priority 0.9
    end
  end

  xml.url do
    xml.loc trending_url
    xml.priority 0.8
  end

  xml.url do
    xml.loc latest_url
    xml.priority 0.8
  end

  xml.url do
    xml.loc most_unliked_url
    xml.priority 0.8
  end

  xml.url do
    xml.loc most_liked_url
    xml.priority 0.8
  end

  xml.url do
    xml.loc unanswered_url
    xml.priority 0.8
  end

  xml.url do
    xml.loc how_to_url
    xml.priority 0.8
  end

  xml.url do
    xml.loc activity_url
    xml.priority 0.5
  end

  xml.url do
    xml.loc contact_url
    xml.priority 0.5
  end

  xml.url do
    xml.loc terms_url
    xml.priority 0.3
  end

  xml.url do
    xml.loc privacy_url
    xml.priority 0.3
  end

  xml.url do
    xml.loc stat_url
    xml.priority 0.3
  end

end	