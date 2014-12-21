class Ans < ActiveRecord::Base
  attr_accessible :ip, :question_id, :req_details, :value, :uid
  
  BAD_WORDS = ["4free", "4u", "accutane", "actos", "acyclovir", "adderall", "adipex", "allegra", "alprazolam", "altace", "ambien", "amoxicillin", "amoxil", "amphetamine", "anal", "anime", "antibiotic", "arousal", "atfreeforum.com", "ativan", "attorney", "augmentin", "azithromycin", "babe", "baccarat", "bdsm", "benadryl", "biaxin", "bitch", "blackjack", "blowjob", "bondage", "boob", "booty", "bowflex", "bulabital", "bupropion", "butalbital", "camry", "car", "carisoprodol", "cartier", "casino", "celebrex", "celexa", "chick", "cialis", "cipro", "citalopram", "claritin", "clonazepam", "cock", "codeine", "codine", "crestor", "crotch", "cruise", "cruises", "cum", "cunt", "cyclen", "cyclobenzaprine", "cymbalta", "dada", "diazepam", "dick", "didrex", "diovan", "directbookmarks.info", "dodge", "doxycycline", "drugstores", "edvttj", "effexor", "elavil", "ephedra", "ephedrine", "erotica", "escort", "estate", "facial", "famvir", "finland", "fioricet", "forex", "freewebs", "fuck", "gambling", "gay", "glucophage", "gucci", "helsinki", "hentai", "holdem", "honda", "hoodia", "horny", "hummer", "hydrochlorothiazide", "hydrocodone", "incest", "indianapolis", "jaguar", "jewelry", "lamictal", "lasix", "lesbian", "lesbians", "levaquin", "levitra", "lexapro", "lexus", "lipitor", "loan", "lopressor", "lorazepam", "masterbating", "mazda", "medication", "meridia", "metalica", "mevacor", "minolche", "myfreedir.info", "mysex", "necklace", "nexium", "nicotine", "nissan", "norvasc", "nude", "orgasm", "orgy", "oxycodone", "oxycontin", "p0tassium", "panties", "panty", "paxil", "penis", "percocet", "pharmacy", "phentermine", "phpbb", "plavix", "poker", "porn", "potassium", "pravachol", "prednisone", "prevacid", "prilosec", "propecia", "protonix", "prozac", "pussy", "rape", "refinance", "ringtones", "ritalin", "rolex", "roulette", "seroquel", "sex", "shemale", "silveno", "slot", "soma", "sphost", "swinger", "tadalafil", "tadalis", "tawnee", "teen", "testosterone", "tetracycline", "tissot", "tit", "toon", "toyota", "tramadol", "trazodone", "twinks", "ultracet", "ultram", "valerian", "valium", "viagra", "vicodin", "vioxx", "wellbutrin", "wholesale", "xanax", "xenical", "xxx", "zanaflex", "zenegra", "zithromax", "zocor", "zoloft", "zolus", "zovirax", "zyprexa", "thx", "byob", "debt", "poze", "visa", "hotel", "naked", "coolhu", "dating", "payday", "rental", "booker", "youtube", "myspace", "advicer", "flowers", "finance", "freenet", "-online", "cumshot", "trading", "top-site", "mortgage", "dutyfree", "ownsthis", "duty-free", "insurance", "hair-loss", "bllogspot", "baccarrat", "thorcarlson", "jrcreations", "credit card", "macinstruct", "leading-site", "slot-machine", "ottawavalleyag", "discreetordering", "aceteminophen", "augmentation", "enhancement", "cephalaxin", "vicoprofen", "oxycontin", "oxycodone", "tramadol", "lunestra", "fioricet", "lexapro", "valtrex", "titties", "vicodin", "breast", "valium", "hqtube", "clomid", "porno", "xanax", "pills", "male", "tits", "shit", "ass", "gdf", "gds"] 

  def self.remove_bad_words(value)
    begin
      ans_a = value.split(/\W+/)
      words_to_replace = []
      ans_a.each do|a| 
        if(Ans::BAD_WORDS.include? a.downcase)
          words_to_replace << a.downcase
        end
      end
      if(!words_to_replace.blank?)
        words_to_replace.each do|w|
          word = w.to_s
          c = w.length
          r = ""
          r[0] = word[0]
          for x in 1..(c-1)
            r[x] = "*"
          end
          value = value.gsub(w, r)
        end
      end
    rescue Exception => ex
      logger.info(ex.to_s)
    end
    return value
  end
  
end
