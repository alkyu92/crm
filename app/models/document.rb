class Document < ApplicationRecord
  belongs_to :opportunity

  has_attached_file :doc, dependent: :destroy,
  # {
  # # Choose the FTP storage backend
  #   :storage => :ftp,
  #
  #   # Set where to store the file on the FTP server(s).
  #   # This supports Paperclip::Interpolations.
  #   :path => "/home/pi/:attachment/:id/:style/:filename",
  #
  #   # The full URL of where the attachment is publicly accessible.
  #   # This supports Paperclip::Interpolations.
  #   :url => "/url_prefix/:attachment/:id/:style/:filename",
  #
  #   # The list of FTP servers to use
  #   :ftp_servers => [
  #     {
  #       :host     => "rpi4",
  #       :user     => "pi",
  #       :password => "rpi4"
  #     }
  #     #,
  #     # Add more servers if needed
  #     #{
  #     #  :host     => "ftp2.example.com",
  #     #  :user     => "foo",
  #     #  :password => "bar",
  #     #  :port     => 2121, # optional, 21 by default
  #     #  :passive  => true  # optional, false by default
  #     #}
  #   ],
  #
  #   # Optional socket connect timeout (in seconds).
  #   # This only limits the connection phase, once connected
  #   # this option is of no more use.
  #   :ftp_connect_timeout => 5, # optional, nil by default (OS default timeout)
  #
  #   # Optional flag to skip dead servers.
  #   # If set to true and the connection to a particular server cannot be
  #   # established, the connection error will be ignored and the files will
  #   # not be uploaded to that server.
  #   # If set to false and the connection to a particular server cannot be established,
  #   # a SystemCallError will be raised (Errno::ETIMEDOUT, Errno::ENETUNREACH, etc.).
  #   :ftp_ignore_failing_connections => true, # optional, false by default
  #
  #   # Optional flag to keep empty parent directories when deleting files.
  #   :ftp_keep_empty_directories => true # optional, false by default
  # },

   # In order to determine the styles of the image we want to save
   # e.g. a small style copy of the image, plus a large style copy
   # of the image, call the check_file_type method
   styles: lambda { |a| a.instance.check_file_type },

   processors: lambda {
     |a| a.is_video? ? [ :ffmpeg ] : [ :thumbnail ]
   }

 do_not_validate_attachment_file_type :doc

 # Before applying the Imagemagick post processing to this record
 # check to see if we indeed wish to process the file. In the case
 # of audio files, we don't want to apply post processing
 before_post_process :apply_post_processing?

 # Helper method that uses the =~ regex method to see if
 # the current document has a content_type
 # attribute that contains the string "image" / "video", or "audio"
 def is_image?
   self.doc.content_type =~ %r(image)
 end

 def is_video?
   self.doc.content_type =~ %r(video)
 end

 def is_audio?
   self.doc.content_type =~ /\Aaudio\/.*\Z/
 end

 def is_plain_text?
   self.doc_file_name =~ %r{\.(txt)$}i
 end

 def is_excel?
   self.doc_file_name =~ %r{\.(xls|xlt|xla|xlsx|xlsm|xltx|xltm|xlsb|xlam|csv|tsv)$}i
 end

 def is_word_document?
   self.doc_file_name =~ %r{\.(docx|doc|dotx|docm|dotm)$}i
 end

 def is_powerpoint?
   self.doc_file_name =~ %r{\.(pptx|ppt|potx|pot|ppsx|pps|pptm|potm|ppsm|ppam)$}i
 end

 def is_pdf?
   self.doc_file_name =~ %r{\.(pdf)$}i
 end

 def has_default_image?
   is_audio?
   is_plain_text?
   is_excel?
   is_word_document?
 end

 # If the uploaded content type is an audio file,
 # return false so that we'll skip audio post processing
 def apply_post_processing?
   if self.has_default_image?
     return false
   else
     return true
   end
 end

 # Method to be called in order to determine what styles we should
 # save of a file.
 def check_file_type
   if self.is_image?
     {
       :thumb => "150x150#",
       :small => "100x100#"
     }
   elsif self.is_pdf?
     {
       :thumb => ["200x250#", :png],
       :small => ["100x100#", :png]
     }

   elsif self.is_video?
     {
       :thumb => {
         :geometry => "150x150#",
         :format => 'jpg',
         :time => 0
       },
       :small => {
         :geometry => "100x100#",
         :format => 'jpg',
         :time => 0
       }
     }
   elsif self.is_audio?
     {
       :audio => {
         :format => "mp3"
       }
     }
   else
    {}
   end
 end
end
