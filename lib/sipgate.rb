require 'xmlrpc/client'

class Sipgate
  
  cattr_accessor :user, :password
  
  def initialize
    @client = XMLRPC::Client.new2("https://#{CGI::escape(self.class.user)}:#{self.class.password}@api.sipgate.net/RPC2")
  end
  
  # versendet ein Fax
  def fax(number, pdf_message)
    number = number.gsub(/^(\+)/, "").gsub(/\s+/,   "")
    
    call "samurai.SessionInitiate", 
    "RemoteUri" => "sip:#{number}@sipgate.net", 
    "TOS" => "fax", 
    "Content" => Base64.encode64(pdf_message)
  end
  
  # fragt den Status eines Faxes ab
  def status(session_id)
    call "samurai.SessionStatusGet",
    'SessionID' => session_id
  end
  
  def call(*args)
    begin
      response = @client.call(*args)
    rescue
      response
    end
  end
    
end