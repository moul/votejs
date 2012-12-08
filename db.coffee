exports.iourl = 'http://dev.onouo.com:9144'

polls = exports.polls =
    1:
        question: "quel age as-tu ?"
        answers:
            0: '0-17'
            1: '18-25'
            2: '26-52'
            3: '52-142'
        private: true
        secret: 'salut'
    2:
        question: "quel est votre projet prefere ?"
        dateEnd: Date.now() + 10000
        registeredUserOnly: true
        allowedUsers: ['azerty', 'bidule', 'salut']
        answers:
            0: "bah votejs..."
            1: "ya d'autres projets ?"
            2: "Une pomme"
            3: "Touche a ton cul"
            4: "Sens ton doigt"
            5: "La reponse D"
    3:
        question: "pile ou face ?"
        answers:
            0: "pile"
            1: "face"
    4:
        question: "combien mesure ton penis ?"
        answers:
            0: "oui"
            1: "non"
            2: "bien au contraire"
    5:
        question: "on mange quoi ce soir ?"
        answers:
            0: "des pates"
            1: "une pizza"
            2: "un sandwish"

for key, poll of polls
    poll.private          ?= false
    poll.id               ?= parseInt key
    poll.dateEnd          ?= null
    poll.canChangeVote    ?= true
    poll.canViewResults   ?= true
    poll.canUnvote        ?= false
    poll.registeredUserOnly ?= false

cache = exports.cache =
    1:
        2: 42
        0: 46

votes = exports.votes = {}
