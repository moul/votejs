polls = exports.polls =
    1:
        question: "quel age as-tu ?"
        answers: [
            '0-17'
            '18-25'
            '26-52'
            '52-142'
        ]
        #public: false
    2:
        question: "quel est votre projet prefere ?"
        answers: [
            "bah votejs..."
            "ya d'autres projets ?"
        ]

for key, poll of polls
    poll.public ?= true
    poll.id ?= key
#console.log polls
