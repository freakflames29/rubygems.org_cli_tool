require "httparty"
require "nokogiri"
require 'clipboard'

$flag=5
$req=nil
$url=""

def userInput
    puts "Which gem you want to find or download ?"
    print "Enter name :- "
    find=gets.strip
    $url="https://rubygems.org/gems/"+find#.downcase
    # puts
end

def printBuff
    while $flag>0
        # print "\033[1;33mFetching the gem🚀  .\r"
        # sleep(0.2)
        # print "\033[1;33mFetching the gem🚀 ..\r"
        # sleep(0.2)
        # print "\033[1;33mFetching the gem🚀 ...\r"
        # sleep(0.2)
        # print "                                  \r"
        # # sleep(0.3)
        # # print "                                  \r"
        # # print "\033[1;33mFetching the gem🚀  .\r"


        print "\033[1;33mFetching the gem 🧐 \\ \r"
        sleep(0.2)
        print "\033[1;33mFetching the gem 🧐 \/ \r"
        sleep(0.2)

    end
    # puts ""
   
end
# puts "\033[1;32m-----------------------"
def scrap (req)
    # if req.body.nil?
        parse=Nokogiri::HTML(req.body)
        download_direct=parse.at_xpath("//*[@id=\"install_text\"]")
        value_of_download_direct=download_direct['value']
        gem_File_data=parse.at_xpath('//*[@id="gemfile_text"]')
        gem_file =gem_File_data['value']

        name_parse=parse.xpath("/html/body/main/div/h1")[0].text
        name=name_parse.gsub!(" ","")
        name_string=name.gsub!("\n"," ")
        ar=name_string.split(' ')

        down_total=parse.xpath("/html/body/main/div/div/div[2]/div[1]/h2[1]/span").text
        latest_version_Download=parse.xpath("/html/body/main/div/div/div[2]/div[1]/h2[2]/span").text
        print " "*50+"\r"
        puts
        puts "\033[1;94mGem name:- #{ar[0]} \033[1;34mLatest Version:- #{ar[1]} "
        puts "\033[1;94mTotal Download:- #{down_total.strip}  \033[1;34mLatest Version Download:- #{latest_version_Download}"
        # puts "                                       "
        puts "\033[1;97m-"*60
        puts "\033[1;32mDirect Install:-\033[1;97m#{value_of_download_direct}"
        puts "\033[1;90m-"*60
        puts "\033[1;96mGemfile Install:-\033[1;97m#{gem_file}"
        
        puts "\033[1;97m-"*60
        puts "\033[1;97mPress 1 for copy \033[1;32mDirect Install , \033[1;97m2 for copy \033[1;96mGemfile Install \033[1;97mor 3 for \033[1;31mabort"
        print "\033[1;97mEnter:- "
        choice=gets.to_i
        case choice
        when 1
            Clipboard.copy(value_of_download_direct)
            puts "\033[1;32mDirect Install Copied ✔"
        when 2 
             Clipboard.copy(gem_file)
             puts "\033[1;32mGemfile Install Copied ✔"
        else
            puts "\033[1;97mBye !"
            exit(0)
        end
    # else
        # puts "----------------------------------------"
        # puts "Fuck me please"
# 
    # end
end
def req
    begin
        $req=HTTParty.get($url)
        if $req.code==200
                $flag=-1
                sleep 0.8
                scrap $req
        else
            # puts "                                 "
            puts "\033[1;31m Sorry Gem not found !😕      "
            exit(1)
        end
    rescue
        puts "\033[1;31mNo connection!🚫  check your internet       "
        exit(1)
    end
end
def thrcall
    a=Thread.new{printBuff}
    b=Thread.new{req}
    a.join
    b.join
end
userInput
thrcall