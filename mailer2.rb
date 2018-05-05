#mail: dansjomailer@gmail.com pw: Metallica1337
#
require 'net/smtp'
require 'tlsmail'
require 'yaml'

class SMTPGoogleMailer

  def send_plain_email from, to, subject, body
    mailtext = <<EOF
From: #{from}
To: #{to}
Subject: #{subject}

    Hej #{to}! 
    Vi har hittat dessa jobb till dig,

    #{body}

EOF
    send_email from, to, mailtext
  end

  private
  def send_email from, to, mailtext
    begin
      Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

      # Net::SMTP.start(@smtp_info[:smtp_server], @smtp_info[:port], @smtp_info[:helo], @smtp_info[:username], @smtp_info[:password], @smtp_info[:authentication]) do |smtp|
      #   smtp.send_message mailtext, from, to
      # end

         Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', 'dansjomailer@gmail.com', 'Metallica1337', 'plain') do |smtp|
           smtp.send_message mailtext, from, to

         end

    rescue => e
      raise "Exception occured: #{e} "
      exit -1
    end
  end
end


#text = 'jobb1'

#mailer = SMTPGoogleMailer.new
#mailer.send_plain_email 'dansjomailer@gmail.com', 'dansjomailer@gmail.com', 'SUBJECT', text

