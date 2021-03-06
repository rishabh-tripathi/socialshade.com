xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "SocialShade - Anonymous way to find answers"
    xml.description "SocialShade is a place where you find answers to those questiosn which are hard to ask with your name, ask anything anonymously and answer others"
    xml.link "http://www.socialshade.com"
    for q in @qu
      xml.item do
        xml.title q.text
        xml.description "#{q.ans} answers so far, submit your openion anonymously"
        xml.pubDate q.created_at.to_s(:rfc822)
        xml.link answer_url(q.id)
        xml.guid answer_url(q.id)
      end
    end
  end
end