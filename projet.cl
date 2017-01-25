;------------------
;------PRESTO------
;------------------



(setq *questions* 

       '(((num_question Q1) (priorite 1) (question "Est-ce que le magicien doit retrouver une seule carte en particulier ?") (reponse_question (oui non)) (regles (R1 R2 R3 R4 R17)) (variable Carte_part))
        ((num_question Q2) (priorite 2) (question "A-t-il fait son tour avec plusieurs cartes ?") (reponse_question (oui non)) (est_sous_question (num_question_mere Q1) (reponse_question_mere non)) (regles ()))
        ((num_question Q3) (priorite 3) (question "Combien de cartes est-ce que le magicien devait retrouver ?") (reponse_question (2 3 4 5 6 7 8 9 10)) (est_sous_question (num_question_mere Q2) (reponse_question_mere oui)) (regles (R5 R6 R22 R23 R8)) (variable nbreCarte))
        ((num_question Q4) (priorite 4) (question "Quel est le type de carte ?") (reponse_question (as 2D)) (est_sous_question (num_question_mere Q2) (reponse_question_mere oui)) (regles (R5 R6 R22 R23 R8)) (variable typeCarte))
        ((num_question Q5) (priorite 5) (question "Est-ce que le magicien a compté les cartes durant le tour ?") (est_sous_question (num_question_mere Q4) (reponse_question_mere as)) (reponse_question (oui non)) (regles (R6)) (variable CompteBiddle))
 
        ((num_question Q6) (priorite 6) (question "Est-ce que le magicien a coupé le paquet durant le tour ?") (reponse_question (oui non)) (regles (R11 R12)))
  ((num_question Q7) (priorite 7) (question "A quelle fréquence à t'il coupé les cartes durant le tour ?") (est_sous_question (num_question_mere Q6) (reponse_question_mere oui)) (reponse_question (une bcp)) (regles (R12)) (variable cut_deck))
  ((num_question Q8) (priorite 8) (question "Est-ce que des mouvements vous ont parut inhabituels durant le tour ?") (reponse_question (oui non)) (regles (R10 R14 R16)) (variable suspect-Mov))
  ((num_question Q9) (priorite 9) (question "Est-ce que les mouvements répondaient à une esthétique particulière") (est_sous_question (num_question_mere Q8) (reponse_question_mere oui)) (reponse_question (oui non)) (regles (R10)) (variable mouvement_carte_remarquable))
  ((num_question Q10) (priorite 10) (question "Est-ce que le magicien vous a semblait avoir les mouvements restreints (au niveau de la main) durant le tour ?") (est_sous_question (num_question_mere Q8) (reponse_question_mere oui)) (reponse_question (oui non)) (regles (R14 R16)) (variable restrict_Mov))
  ((num_question Q11) (priorite 11) (question "Est-ce que le magicien vous a posé des questions durant le tour ?") (reponse_question (oui non)) (regles (R18)) (variable questions_sans_liens))
  ((num_question Q12) (priorite 12) (question "A-t-il chercher à établir un contact visuel avec vous durant le tour ?") (reponse_question (oui non)) (regles (R18)) (variable contact_visu))
  ((num_question Q13) (priorite 13) (question "Est-ce que le magicien à demander de poser toute votre attention sur quelque chose en particulier durant le tour ?") (reponse_question (oui non)) (regles (R19)) (variable demande_att))
  ((num_question Q14) (priorite 14) (question "Est-ce que le magicien vous à donné des infos sur ce qu'il allait faire ou sur le tour en général durant le tour ?") (reponse_question (oui non)) (regles (R20 R22)) (variable donne_info))
  ((num_question Q17) (priorite 15) (question "Est-ce que le magicien a retourne le paquet durant le tour ?") (reponse_question (oui non)) (regles (R3)) (variable carteRetounee))
  ((num_question Q15) (priorite 16) (question "Est-ce que le magicien était en train de tenir les cartes nonchalament dans sa main ?") (est_sous_question (num_question_mere Q14) (reponse_question_mere oui)) (reponse_question (oui non)) (regles (R22)) (variable Hold_card))
  ((num_question Q16) (priorite 17) (question "Est-ce que le magicien vous a raconté une histoire pour faire son tour ?") (reponse_question (oui non)) (regles (R21)) (variable story))
  ))



(setq baseRegle '(   ;;Tours de magie
                     ;;-------------- 

          (R1 ((nbreCarte . 1) (fausse_explication . t) (leve2 . t)) (tour1 . colorChange1))   ;;Changement de carte
          (R2 ((nbreCarte . 1) (Misdir . moderate) (empalmage . t)) (tour1 . colorChange2))
          (R3 ((nbreCarte . 1) (pinky_break . t) (carteRetounee . t) (fausse_explication . t)) (tour2 . triomphe))
          (R4 ((nbreCarte . 1) (Misdir . strong) (cardControl . bcp) (leve2 . t) (tour1 . triomphe) (pliageCarte . t)) (tour2 . carte_Ambitieuse)) 
          (R5 ((nbreCarte . 4) (typeCarte . As) (Misdir . weak)) (tour1 . as_du_tricheur))
          (R6 ((nbreCarte . 4) (typeCarte . As) (CompteBiddle . t)) (tour1 . Disparition_de_l_as))
          (R30 ((nbreCarte . 4) (typeCarte . 2D)) (tour1 . 2_de_carreaux_en_folies))
          (R23 ((nbreCarte . 2) (Misdir . moderate) (leve2 . t)) (tour1 . kissing_card_trick))

          ;;Mouvements Cartes
          ;;----------------- 

          (R7 ((pinky_break . t) (false_cut . t) (control_cut . t)) (cardControl . t))
          (R8 ((nbreCarte . 4) (comptage_carte . t) (face_retournee . t)) (CompteBiddle . t))             
          (R9 ((Misdir . moderate) (Hold_card . t)) (pinky_break . t))                
          (R10 ((mouvement_carte_remarquable . t)) (fioriture . t))
          (R11 ((fioriture . t) (cut_deck . bcp)) (false_cut . t))
          (R12 ((cut_deck . bcp)) (control_cut . t))      ;;il y a un OU pour cette regle
          (R24 ((passe . t)) (control_cut . t))
          (R13 ((control_cut . t)) (false_cut . t))
          (R14 ((Misdir . strong) (suspect-Mov . t)) (passe . t))
          (R15 ((Misdir . strong) (empalmage . t) (control_cut . t)) (pliageCarte . t))
          (R16 ((suspect-Mov . t) (restrict_Mov . t)) (empalmage . t))
          (R17 ((pinky_break . t)) (leve2 . t))
          (R25 ((Carte_part . t)) (nbreCarte . 1))

          ;;Detournement d'attention
          ;;------------------------

          (R18 ((parole_Mag . questions_sans_liens) (contact_visu . t)) (Misdir . strong))
          (R19 ((parole_Mag . demande_att)) (Misdir . strong))
          (R20 ((parole_Mag . donne_info)) (Misdir . moderate))
          (R21 ((parole_Mag . story)) (Misdir . weak))
          (R22 ((parole_Mag . donne_info) (Hold_card . t)) (fausse_explication . t))
          (R26 ((story . t)) (parole_Mag . story))
          (R27 ((demande_att . t)) (parole_Mag . demande_att))
          (R28 ((donne_info . t)) (parole_Mag . donne_info))
          (R29 ((questions_sans_liens . t)) (parole_Mag . questions_sans_liens))

  ))




(setq *BF*

  '((nbreCarte . 0) (fausse_explication . nil) (leve2 . nil) (misdir . nil) (empalmage . nil) (pinky_break . nil) (nbcardCont . 0) (pliageCarte . nil) 
     (typeCarte . nil) (CompteBiddle . nil) (false_cut . nil) (control_cut . nil) (cardControl . nil) (comptage_carte . nil) (face_retournee . nil) (Hold_card . nil)
     (mouvement_carte_remarquable . nil) (fioriture . nil) (cut_deck . nil) (passe . nil) (suspect-Mov . nil) (restrict_Mov . nil) (tour1 . nil) (tour2 . nil)
    )
  )




(setq buts '(colorChange1 colorChange2 triomphe carte_Ambitieuse as_du_tricheur Disparition_de_l_as 2_de_carreaux_en_folies kissing_card_trick))



;;Fonctions pour gérer la base de question
;;----------------------------------------

(defun poserQuestion (question)
  (let ((reponse nil) 
        (reponseInterface nil) 
        (questionPosee (cadr (assoc 'question question)))
        (listeReponsePossibles (cadr (assoc 'reponse_question question))))
    
   (while (not (member reponse listeReponsePossibles))
     (format t "~%~a (modalités de réponse : ~a)~%" questionPosee listeReponsePossibles)
     (setq reponseInterface (read-line))
     (cond 
      ((or (equal reponseInterface "oui") (equal reponseInterface "OUI")) (setq reponse 'oui))
      ((or (equal reponseInterface "non") (equal reponseInterface "NON")) (setq reponse 'non))
      ((or (equal reponseInterface "je ne sais pas") (equal reponseInterface "JE NE SAIS PAS")) (setq reponse 'jnsp))
      ((or (equal reponseInterface "beaucoup") (equal reponseInterface "BEAUCOUP")) (setq reponse 'bcp))
      ((or (equal reponseInterface "une") (equal reponseInterface "UNE")) (setq reponse 'une))
      ((or (equal reponseInterface "as") (equal reponseInterface "As")) (setq reponse 'as))
      ((or (equal reponseInterface "2d") (equal reponseInterface "2D")) (setq reponse '2d))
      ((or (equal reponseInterface "bcp") (equal reponseInterface "BCP")) (setq reponse 'bcp))
      (T   (setq reponse (parse-integer reponseInterface)))
     ))
    (return-from poserQuestion reponse)
    ))

(defun selectionQuestion (liste_question)
  (let ((selectionQuestion (car liste_question)) 
        (proriteQuestion (cadr (assoc 'priorite (car liste_question)))))
    (dolist (elem liste_question selectionQuestion)
      (setq proriteElem (cadr (assoc 'priorite elem)))
        (if (< proriteElem proriteQuestion)
          (progn
            (setq proriteQuestion proriteElem)
            (setq selectionQuestion elem)))
      )
    ))
    
(defun selectionRegleQuestion (question reponse)
  (let ((listeReglesQuestionCandidates nil) (reponseTrouve nil) (regleChoisie nil))
    (dolist (elem *reglesQuestions*)
      (if (= (car elem) (car question))
          (push elem listeReglesQuestionCandidates))
      )
    (while (null reponseTrouve)
      (if (equal (cadar listeReglesQuestionCandidates) reponse)
          (progn 
            (setq reponseTrouve T)
            (setq regleChoisie (car listeReglesQuestionCandidates))))
      (pop listeReglesQuestionCandidates))
    (return-from selectionRegleQuestion regleChoisie)
    ))

(defun supressionToutesSousSousQuestion (numSousQuestion)
  (let ((elemSousQuestion nil)
        (numQuestionMere nil)
        (numSousSousQuestion nil))
    
    (if (not (null numSousQuestion))
        (dolist (elem liste_question liste_question)
          (setq elemSousQuestion (cdr (assoc 'est_sous_question elem)))
          (if (not (null elemSousQuestion)) 
              (progn
                (setq numQuestionMere (cadr (assoc 'num_question_mere elemSousQuestion)))
                (if (equal numSousQuestion numQuestionMere)                
                    (progn
                      (setq numSousSousQuestion (cadr (assoc 'num_question elem)))
                      (setq liste_question (remove elem liste_question))
                      (supressionToutesSousSousQuestion numSousSousQuestion)))
                )))
      )))

(defun supprimerSousQuestion (coupleQuestionReponse liste_question)
  (let ((elemSousQuestion nil)
        (numQuestionMere nil)
        (reponseQuestionMere nil)
        (numSousQuestion nil))
          
    (dolist (elem liste_question liste_question)
      (setq elemSousQuestion (cdr (assoc 'est_sous_question elem)))
      (if (not (null elemSousQuestion))
          (progn
            (setq numQuestionMere (cadr (assoc 'num_question_mere elemSousQuestion)))
            (setq reponseQuestionMere (cadr (assoc 'reponse_question_mere elemSousQuestion)))
            
            (if (and (equal (car coupleQuestionReponse) numQuestionMere) (not (equal (cadr coupleQuestionReponse) reponseQuestionMere)))                
                (progn
                  (setq numSousQuestion (cadr (assoc 'num_question elem)))
                  (setq liste_question (remove elem liste_question))
                  (supressionToutesSousSousQuestion numSousQuestion)))
                  )))))



(defun Question_1premisse (basefait baseregle questions)(let ((val 0) (prem) (quest) (prio 16))
  (dolist (regle baseregle quest)
    (setq val (length (premisse (car regle) baseregle)))
    (dolist (p (premisse (car regle) baseregle) val)
      (if (member p basefait :test #'equal) (setq val (- val 1)) (setq prem p))
    )
    (if (eq val 1) (progn (dolist (q questions quest)
                      (if (and (not (assoc 'est_sous_question q)) (and (< (prioQuestion q) prio) (equal (car prem) (variableQuestion q)))) (progn (setq quest q) (setq prio (prioQuestion quest))))
                    )))
    )
     quest                                                     
  )
)


(defun prioQuestion (question)
  (cadr (assoc 'priorite question)))




;;Moteur d'inférence
;;------------------

(defun moteurInference ()
  (format t "~%~%")
  (affich)
  (format t "Merci d'avoir lance PRESTO, votre systeme expert a l'epreuve des magiciens ~%")
  (format t "PRESTO est un systeme expert developpe par GALASSO Guillaume et MAZGAJ Alexandre ~%")
  (format t "-------------------------------------------------------------------------------------------- ~%~%")
  (defparameter liste_question *questions*)
  (setq *baseFait* *BF*)
  (let ((QuestionAPoser 'wesh) (reponse) (regleAppli))

    (while (and (not (est_dans_buts *baseFait* buts)) (not (equal liste_question nil)))
     ;;On recupere la reponse et on change la base de fait
     (setq QuestionAPoser (selectionQuestion liste_question))
     (setq ReponseQuestionAPoser (poserQuestion QuestionAPoser))
     (setq liste_question (remove QuestionAPoser liste_question))
     (setq liste_question (supprimerSousQuestion (list (cadr (assoc 'num_question QuestionAPoser)) ReponseQuestionAPoser) liste_question))
     (setq reponse (Recuperer_la_reponse QuestionAPoser ReponseQuestionAPoser))
     (ChangerBaseFait reponse)
     ;On va parcourir les regles applicables avec la base de fait actuelle
     (setq regleAppli (regleCand *baseFait* baseregle))
     (while (not (eq regleAppli nil))
      (dolist (r regleAppli)
          (if (not (member (conclusion r baseregle) *baseFait* :test #'equal))
            (progn
              (ChangerBaseFait (conclusion r baseregle))
              (setq regleAppli (regleCand *baseFait* baseregle))
      ))))
     ;;On va poser une question permettant de repinde a une regle à laquelle il manque une seule premisse
     (setq QuestionAPoser (Question_1premisse *baseFait* baseregle liste_question))
     (if (not (eq QuestionAPoser nil))
      (progn
        (setq ReponseQuestionAPoser (poserQuestion QuestionAPoser))
        (setq liste_question (remove QuestionAPoser liste_question))
        (setq liste_question (supprimerSousQuestion (list (cadr (assoc 'num_question QuestionAPoser)) ReponseQuestionAPoser) liste_question))
        (setq reponse (Recuperer_la_reponse QuestionAPoser ReponseQuestionAPoser))
        (ChangerBaseFait reponse)
        (setq regleAppli (regleCand *baseFait* baseregle))
        (while (not (eq regleAppli nil))
          (dolist (r regleAppli)
              (progn
                (ChangerBaseFait (conclusion r baseregle))
                (setq regleAppli (regleCand *baseFait* baseregle))
    ))))))
    (print *baseFait*)
    (format t "~%Le tour auquel vous avez assisté est ~s~%~%" (est_dans_buts *baseFait* buts))
    (format t "Tutorial :~%~%")
    (format t "~s~%" (eval (est_dans_buts *baseFait* buts)))
    (format t "~%Merci d'avoir utilisé PRESTO ~%")
))

; liste_question


(defun est_dans_buts (*baseFait* buts) (let (tour)
                                         (setq tour (cdr (assoc 'tour2 *baseFait*)))
                                         (if (eq tour nil) (setq tour (cdr (assoc 'tour1 *baseFait*))))
                                         (if (member tour buts) tour (return-from est_dans_buts nil))
                                         ))




(defun conclusion (regle baseregle) (caddr (assoc regle baseregle)))




(defun ChangerBaseFait (conclu)
  (if (not (equal conclu nil))
    (if (and (listp conclu) (assoc (car conclu) *baseFait*))        ;Acutalise la base fait 
        (setf (cdr (assoc (car conclu) *baseFait*)) (cdr conclu))
        (push conclu *baseFait*))))





(defun Recuperer_la_reponse (QuestionAPoser ReponseQuestionAPoser) (let (variable)
  (if (assoc 'variable QuestionAPoser)
    (progn
      (setq variable (cadr (assoc 'variable QuestionAPoser)))
      (cond
          ((equal ReponseQuestionAPoser 'non) (setq ReponseQuestionAPoser nil))
          ((equal ReponseQuestionAPoser 'oui) (setq ReponseQuestionAPoser T))
        )

      (cons variable ReponseQuestionAPoser)))))



            

(defun regleCand (etat baseregle) (let ((lbis) (verif))                             ;Determine quelles regles sont applicables et les renvoies sous forme de liste      
                                      (dolist (elem baseregle lbis)                                                                   
                                          (loop for x in (cadr elem) do 
                                                (if (not (member x etat :test #'equal)) (prog1 (setq verif t) (return-from nil))))       
                                        (if (and (not (eq verif t)) (not (member (conclusion (car elem) baseregle) etat :test #'equal))) (setq lbis (append lbis (list (car elem)))))
                                        (setq verif nil)
                                        )))



(defun premisse (regle baseregle)
  (cadr (assoc regle baseregle)))


(defun variableQuestion (question)
  (cadr (assoc 'variable question)))
  

(setq colorChange1 "Le tour auquel vous avez assisté correspond a un changement de carte, le tour est tres simple, le magicien vous dit qu'il va prendre la premiere carte du paquet alors qu'il prend les deux premieres (en donnant l'illusion de n'en prendre qu'une), il les retourne, vous presente la carte du dessous, les retournes sur le paquet, puis il prend la carte du dessus. Ce mouvement s'appel la levée double, vous pouvez trouver des renseignements très facilement sur ce mouvement sur internet")

(setq  colorChange2 "le tour auquel vous avez assisté correspond a un changement de carte, le magicien a tout simplement empalmé (mis la carte dans sa paume) une carte, vous a presenté la premiere carte du paquet, puis a replacer la carte dans sa main sur le dessus du paquet, et ainsi il change la carte")

(setq triomphe "le tour auquel vous avez assisté correspond a un triomphe, le magicien vous a fait pioché une carte qu'il a ensuite controlé sur le bas du paquet à l'aide de coupes et mélanges diverses. Il a ensuite fait semblant de faire des groupes de cartes a l'envers dans le paquet, mais il a simplement fait 2 groupes de cartes inversé dans le paquet, avec votre carte se retrouvant au dessus du paquet. Lorsqu'il vous montre l'état du paquet, le magicien retourne le paquet du dessus, votre carte se retrouvant à l'envers et le paquet dans le bon sens")

(setq carte_Ambitieuse "le tour auquel vous avez assisté correspond a une carte Ambitieuse, le magicien a tout simplement controlé la carte durant tout le tour soit sur le dessus soit sur le dessous du paquet, en suite il a réalisé le tour TRIOMPHE puis tout en parlant avec le public, il a plié la carte dans sa main, a posé la carte pliée en dessous du paquet, puis en mettant le paquet dans sa bouche, la carte pliée se trouve dans sa bouche")

(setq as_du_tricheur "Le tour auquel vous avez assité correspond aux as du tricheur, le magicien a controle chaque as soit sur le dessus, soit sur le dessous, le premier as est perdu a la 9eme position dans le petit paquet, le 2eme est controlé sur le dessus avec une carte quelconque au dessus, le 3eme est placé sur le dessus avec une carte quelconque sur le dessus, la derniere est placé sur le dessous avec une carte quelconque en dessous d'elle, le magicien n a plus qu a retirer les cartes quelconques en faisant semblant de couper le paquet")

(setq Disparition_de_l_as "Le tour auquel vous avez assisté correspond a la disparition de l as, le magicien en vous presentant les as a place le 3eme as qu'il vous presente en dessous du paquet, l'as se retrouve donc retourne face au paquet, ensuite en faisant un compte du biddle, il vous fait croire qu'il a 4 as dans sa main alors qu'il n'en a que 3, il a juste a coupe le paquet pour faire apparaitre l as disparu")

(setq 2_de_carreaux_en_folies "Le tour auquel vous avez assisté correspond aux 2 de carreaux en folies, le magicien a dans sa main, un 2 de carreaux, un dix de pique et 2 rois de carreaux, il fait des levee double durant tout le tour")

(setq kissing_card_trick  "Le tour auquel vous avez assisté correspond au kissing card trick, le magicien a deux cartes pareil, une qu'il signe et l'autre non. Il place au dessus du paquet, la carte signé, puis la carte du public, puis la carte non signé, il fait une levée double pour faire signé la carte du public, puis donne la carte deja signe au spectateur en la pliant, il refait une levee double pour signe la carte non signe puis prend la carte du spectateur qui est reste sur le dessus du paquet")

                                   


(defun logo ()
(format t "_________________§§§§§§§§__________§§_____§§                  ____    ____    _____   ____   _____   ___~%")  
(format t "_______________§§________§§_______§§§§___§§§§                 |  _ \  |  _  |    | ____| / ___| | _   _|  / _  ~%")
(format t "_____________§§__§§§§§§§§__§§______§§_____§§                  | |_) | | |_) |   |  _|    |___ |    | |     | | | |~%") 
(format t "____________§§__§§______§§__§§______§§___§§                   |  __/  |  _ <   | |___   ___) |   | |    | |_| |~%") 
(format t "___________§§__§§___§§§__§§__§§_____§§§§§                      |_|     |_|  |_|   |_____||____/   |_|     \___/ ~%")
(format t "___________§§__§§__§__§__§§__§§_____ §§§§§~%")
(format t "___________§§__§§__§§___§§§__§§_____§§§§§~%")
(format t "___________§§__§§___§§§§§§__§§_____§§§§§§~%")
(format t "____________§§__§§_________§§_____§§§§§§~%")
(format t "_______§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§~%")
(format t "___§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§~%")
(format t "___§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§~%")
(format t "~%")
(format t "merci a Julien Jerphanion pour l'idee du logo~%")
)


                                                
(defun affich () (let ((compt 45))
                   (format t "CHARGEMENT...~%")
                   (dotimes (x compt)
                     (if (> x 30)
                         (format t "==")
                         (format t "="))
                     (sleep (- 0.2 (* 0.003 x)))
                     (setq compt (- compt 1)))
                   (format t "~%~%")
                   (logo)
                   (format t "~%~%")
                   ))





;;Jeu de données 
;;--------------
;;vous pouvez essayer notre moteur en cherchant un tour de magie sur youtube,
;; nous vous conseillons : "kissing card trick" "color change" "triumph" "les as du tricheur de Dominique Duvivier"

;;pour lancer le moteur d'inference -> (moteurinference)
;;Si jamais la petite animation de lancement du moteur d'inference vous agasse, 
;;il vous suffit de mettre en commentaire la fonction (affich) à la ligne 213 (au début de la fonction (moteurinference))

;;Voici les réponses qu'il faut mettre pour retrouver quelques tours :
;;La disparition de l'as : non -> non -> oui -> non -> 4 -> oui -> as -> oui //
;;Le changement de carte : oui -> non -> non -> oui -> non -> oui -> non -> oui //
;; Triomphe : oui -> non -> non -> non -> non -> oui -> non -> oui -> oui //







