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
        answers:
            0: "bah votejs..."
            1: "ya d'autres projets ?"

for key, poll of polls
    poll.private ?= false
    poll.id ?= parseInt key
#console.log polls

cache = exports.cache =
    1:
        2: 42
        0: 46

votes = exports.votes =
    1:
        poll: 1
        date: Date(345678914)
        answer: 0
    2:
        poll: 1
        answer: 2
        date: Date(1232435)
    3:
        poll: 2
        answer: 0
