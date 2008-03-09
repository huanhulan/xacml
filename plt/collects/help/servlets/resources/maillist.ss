(module maillist mzscheme
  (require (lib "servlet-helpers.ss" "web-server"))
  
  (require "../private/headelts.ss")
  
  (require (lib "servlet.ss" "web-server"))
  (provide interface-version timeout start)
  (define interface-version 'v1)
  (define timeout +inf.0)
  
  (define (start initial-request)
    (report-errors-to-browser send/finish)
    
    `(HTML 
      (HEAD ,hd-css
            ,@hd-links
            (TITLE "Mailing Lists"))
      (BODY 
       (A ((NAME "mail") (VALUE "mailing lists")))
       (H1  "Mailing Lists")
       "PLT maintains two English-language mailing lists: one for announcements, "
       "the other for discussion.  There is a discussion list in Spanish." 
       (P)
       (HR)
       (P)
       (B "Announcements List") (BR)
       "The announcement-only list is designed for people who need to "
       "track releases and patches.  The list is moderated. "
       "There are a handful of postings a year."
       (P)
       "To subscribe to " (TT "plt-announce@list.cs.brown.edu") ", visit the "
       "Web page "
       (BLOCKQUOTE
        (A ((HREF "http://list.cs.brown.edu/mailman/listinfo/plt-announce/")
            (TARGET "_top")) "http://list.cs.brown.edu/mailman/listinfo/plt-announce/"))
       " or send email to "
       (BLOCKQUOTE
        (A ((HREF "mailto:plt-announce-request@list.cs.brown.edu"))
           "plt-announce-request@list.cs.brown.edu"))
       " with the word `help' in the subject or body of the message. "
       "You'll get back a message with instructions."
       (P)
       (HR)
       (P)
       (B "Discussion List") (BR)
       "If you have problems with installation, or questions about "
       "using PLT Scheme, send mail to the list " 
       (BLOCKQUOTE 
        (A ((HREF "mailto:plt-scheme@list.cs.brown.edu")) "plt-scheme@list.cs.brown.edu"))
       (P)
       "Only subscribers can post to the list. To subscribe, visit the Web page "
       (BLOCKQUOTE
        (A ((HREF "http://list.cs.brown.edu/mailman/listinfo/plt-scheme/")
            (TARGET "_top")) "http://list.cs.brown.edu/mailman/listinfo/plt-scheme/"))
       " or send email to "
       (BLOCKQUOTE
        (A ((HREF "mailto:plt-scheme-request@list.cs.brown.edu")) "plt-scheme-request@list.cs.brown.edu"))
       " with the word `help' in the subject or body of the message. "
       "You'll get back a message with instructions."
       (P)
       (HR)
       (P)
       (A ((NAME "mail-es") (VALUE "Spanish mailing lists")))
       (A ((NAME "mail-es2") (VALUE "Lista de Correo")))
       (B "Lista de Correo") (BR)
       "Si tienes problemas con la instalaci�n o preguntas sobre el "
       "uso de PLT Scheme, env�a un mensaje a la lista "
       (BLOCKQUOTE 
        (A ((HREF "mailto:plt-scheme-es@list.cs.brown.edu")) "plt-scheme-es@list.cs.brown.edu"))
       "Para reducir la recepci�n de mensajes no deseados (SPAM), "
       "hemos adoptado la pol�tica de que s�lo los suscriptores a la lista "
       "pueden enviar mensajes. Para suscribirte, visita la p�gina de Web "
       (BLOCKQUOTE
        (A ((HREF "http://list.cs.brown.edu/mailman/listinfo/plt-scheme-es/")
            (TARGET "_top")) "http://list.cs.brown.edu/mailman/listinfo/plt-scheme-es/"))
       " o env�a un mensaje a "
       (BLOCKQUOTE
        (A ((HREF "mailto:plt-scheme-es-request@list.cs.brown.edu")) "plt-scheme-es-request@list.cs.brown.edu"))
       " con la palabra `help' en el asunto o en el cuerpo de tu mensaje. "
       "Recibir�s un mensaje de regreso con instrucciones."))))