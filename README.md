Scripts for accessing the OpenAI API from the terminal.

WHAT DOES IT DO?

Quickly makes a call to the OpenAI API, stores the results in a specified directory for notes, and
outputs ChatGPT's response with Markdown formatting.

If you use a searchable, backed-up knowledgebase, this means that anything you run through this
tool gets added to your own KB. I like Obsidian [[https://obsidian.md]]

I recommend aliasing the script here:

```
alias ai="~/ai.sh"
```

The script can then be invoked as:

```
$ai "Your prompt here."
```

WHY?

I'm starting to see a lot of tools out there that promise interfacing with ChatGPT's APIs, yet
this API is one of the simplest, most straightforward I've ever used. POST goes in data comes out.

Also, I live in and love the terminal, and this is just faster and less friction for me.

Enjoy at your own risk. :)

DISCLAIMERS

Anything here is really intended for my own personal use, and contains a bare limit of best practice.
There are a lot of cases it doesn't handle. I don't care. This is to provide quick one-off answers
which are my most common use case.

Yes, I can code prettier than this.
