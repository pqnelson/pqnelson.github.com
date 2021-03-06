---
layout: post
title: News Macros for Emacs
published: true
quote: "One of the greatest threats to freedom in the world is propaganda."
quoteSource: Douglas S. Freeman, as recounted in David E. Johnson's <i>Douglas Southall Freeman</i> (2002)
tags: [Emacs]
---

# Introduction

## Problem Statement

Reading the news seems to be a thing of the past: now we have to
_research_ the news. To jump to the solution, see the section <a
href="#quickstart">How to use this thing?</a>

## Outline of a Solution

I was struck by David E. Johnson's _Douglas Southall Freeman_, a
biography of the Virginian historian who edited the _Richmond News
Leader_ (a daily newspaper). Dr Freeman apparently took on the role of
the paper's librarian --- every (major) newspaper has its own
"librarian" that's available for reference information. Johnson describe
Freeman's organizational methodology:

> The reporters soon noticed the effects of having a historian as an
> editor. Under the old filing system, articles were clipped and filed,
> creating cumbersome overflowing files cntaining various-sized
> yellowing clips.
> Freeman developed and instituted a system modeled closely on his
> research methods. Each day he prepared an index of items from the
> pages of the Richmond papers and the _New York Times_ considered to
> have value for future reference. On the same sheet were noted magazine
> articles, pamphlets, and book references from that same day. The
> entries were then typed on topical file cards. Successive entries,
> regarding the same subject, were added to the card, and no clippings
> were made. A reporter could thus find a detailed and chro9nological
> summary of a given subject by glancing at the topical subject
> cards. If more information was needed, he could refer to the bound
> volume of index sheets or, finally, to the original newspaper or
> magazine in the library. (_Douglas Southall Freeman_, 110)

For comparison to Freeman's method as historian (discussed in detail
pages 329--331), the basic algorithm was:

0. Read the source material
0. "Once it was determined that a letter, book, or manuscript contained
   information that might be useful, the next decision was what type of
   note to make of it. There were three categories of notes: 'Now or
   Never Notes' which contained 'absolutely ncessary' information;
   'Maybe Notes' with a brief summary of the information; and 'Companion
   Notes' that gave the pages and citations to a source close at hand." (329)
0. "Whatever the category, note taking was done in a consistent
   form. The cards---called 'quarter sheets'---were 5.5-by-4.25 inches
   [i.e., literally a quarter of a piece of American writing paper]. In
   the upper left corner of the card the date was noted---year, month,
   day. In the upper right, the source and page citation. The subject
   was written in the center-top of the card. A brief abstract of the
   contents of the item was typed across the card." (329) An example
   from Freeman's research on George Washington looked like:
   
   > 1781, Sept. 13 ADVANCE J.Trumball's Diary, 333
   >
   > Leave Mount Vernon, between Colchester and Dumfries, meet letters
   > that report action between two fleets. French have left Bay in
   > pursuit---event not known. "Much agitated."
0. "Supplementing the cards were 'long sheets' held in three-ring
   binders. The long sheets contained more details from the source;
   often including entire letters or lengthy extracts. The cards were
   filed chronologically, the long sheets by topic." (330)
0. Once a particular source has been thoroughly examined, Freeman later
   in his life (while working on his biography of George Washington)
   numbered the cards with something called a "numbering machine".
0. "With the cards and long sheets complete, Freeman recorded the
   information in another notebook, a sort of working outline. In these
   entries, key words were capitalized so he could tell at a glance what
   his subject was dealing with at a particular moment. His notebook
   page for George Washington on August 17, 1775, has two words
   capitalized: POWDER and QUARTERMASTER." (330)
0. "The cards, long sheets, and notebooks were cross-referenced and
   carried identical numbers if they touched on the same topic. For a
   fact to be lost or slip through the cracks would require failure at
   four different places." (330)

## Implementing a Solution (Sketch)

With this outline in mind, it seemed like it could be expedited using
Emacs org-mode plus some custom macros to (1) download an article, (2)
cite an article, (3) tag keywords. Fortunately most news sources already
tag the keywords, so it becomes a matter of parsing the HTML for certain
tags.

It'd be really nice if I could (in org-mode):

0. write my outline by subject
0. simply paste in links as I read articles and determine they are useful, then
0. after I'm done, run a single command that will
   0. look for raw links (i.e., ones that are not org-mode link
      constructs), and for each link 
   0. download the article, then
   0. replace the raw link with an org-mode link that schematically looks like
      `[[url][article title]]`.

This requires writing some macros to intelligently download articles,
parse their HTML for useful information (like the title, or the tags),
then insert useful information into the org-mode buffer.

The source code is available on [github](https://github.com/pqnelson/dsf-news)
under the MIT license.

# Macros for Downloading an Article

I opted to download a copy of the article for future reference, in case
I need to read it again. The organizational scheme was:
- Have a directory `~/news/`
- For each news sources (e.g., `nytimes.com`, `economist.com`, etc.),
  have a corresponding subdirectory (e.g., `~/news/nytimes.com/`,
  `~/news/economist.com/`, etc.) which would store the corresponding articles.

This requires parsing a URL for its domain, which could be done using
the built-in `url` library GNU-Emacs provides:

```elisp
(require 'url)

;; (url-domain (url-generic-parse-url "https://www.google.com"))
;; => "google.com"
;; (url-domain "http://www.nytimes.com/2016/12/21/us/politics/kansas-republicans-democrats-elections.html")
;; => "nytimes.com"
(defun url-domain (url)
  (let ((host (url-host (if (url-p url)
                            url
                          (url-generic-parse-url url)))))
    (if (string-prefix-p "www." host)
        (substring host 4) ; trim the leading "www."
      host)))
```

Then I needed to actually download the article. There are variations on
the same method, but [StackOverflow](http://stackoverflow.com/a/4452695)
provides a decent solution.

```elisp
(defun download-file (&optional url download-dir download-name)
  "Download a given URL into a DOWNLOAD-DIR (defaults to ~/downloads/).
May rename the file using DOWNLOAD-NAME parameter."
  (interactive)
  (let ((url (or url
                 (read-string "Enter download URL: "))))
    (let ((download-buffer (url-retrieve-synchronously url)))
      (save-excursion
        (set-buffer download-buffer)
        ;; we may have to trim the http response
        (goto-char (point-min))
        (re-search-forward "^$" nil 'move)
        (forward-char)
        (delete-region (point-min) (point))
        (write-file (concat (or download-dir
                                "~/downloads/")
                            (or download-name
                                (car (last (split-string url "/" t))))))))))
```

With all the information provided, I did not want to download the same
article twice accidentally. So the basic solution was:

- Determine the path where the article would be saved to
- Check if the article has already been saved, if so...stop, we're done.
- Otherwise, download the file.

It is nicely idempotent.

```elisp
(defvar news-dir "~/news/")

(defun download-article (url)
  "Downloads an article given the URL to `news-dir'. If the file
has already been downloaded, then *do not* download it again."
  (let ((dir (concat news-dir (url-domain url) "/"))
        (file-name (car (last (split-string url "/" t)))))
    (if (file-exists-p (concat dir file-name))
        nil
      (download-file url dir file-name))))

;; (download-article "http://www.nytimes.com/2016/12/21/us/politics/kansas-republicans-democrats-elections.html")
```

# Macros for Parsing an Article

GNU Emacs also has some library for rudimentary
[html parsing](https://www.gnu.org/software/emacs/manual/html_node/elisp/Document-Object-Model.html#Document-Object-Model)
that will transform `<html><head></head><body width=101><div
class=thing>Foo<div>Yes` into

```
(html nil
 (head nil)
 (body ((width . "101"))
  (div ((class . "thing"))
   "Foo"
   (div nil
    "Yes"))))
```

The parsing commands are quite straightforward:

```elisp
(defun html-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (libxml-parse-html-region (point-min) (point-max))))
```

Accessing the dom elements, first we use a number of helper functions to
get the [og:title](http://ogp.me/) and related tags:

```elisp
(require 'dom)

(defun meta-tag/content (node)
  (dom-attr node 'content))

(defun meta-tags (dom)
  (dom-by-tag dom 'meta))

(defun og-title (dom)
   "Returns the content attribute of the og:title meta tag"
   (meta-tag/content (dom-elements dom 'property "og:title")))
```

# Handling Different News Sources

One problem I faced was: different news sources store the title, the
publication datetime, and (when available) the tags -- each of these
differently. The solution I came up with was to have a generic news
source class which would have 3 methods: `title`, `published`, and
`tags` which would "eat it" the news source plus the article's DOM, then
produced the desired string.

So we had one data structure to keep track of the data extracted from an
article, which schematically looked like:

```elisp
(defclass news--article nil
  ((url
    :initarg :url
    :initform ""
    :documentation "Where the article lives on the inter-webs")
   (title
    :initarg :title
    :initform ""
    :documentation "The title of the article")
   (published
    :initarg :published
    :initform ""
    :documentation "Publication date for the article, when available")
   (tags
    :initarg :tags
    :initform nil
    :documentation "Tags the publication assigns to the article; right
  now, it is just a list of strings")))
```

The news source then was just a simple "empty" class

```elisp
(defclass news--source () ; No superclasses
  ())
```

The methods would vary depending on the news source, e.g.,

```elisp
(defmethod published ((s news--source) dom)
  (og-published dom))
```
  
## Adding a new News source

You can add a new news-source using the macro `(dsf-defsource host-str
methods*)`. For example, _The Economist_ is handled with the command:

```elisp
(dsf-defsource "economist.com"
  ((:published (dom)
    (or (dom-attr (dom-by-tag dom 'time) 'datetime) ; published articles
        (sailthru-date dom))))) ; blog articles
```

The methods currently accepted are `:published`, `:title`, and `:tags`.

- `:published` is expected to produce an ISO 8601 datetime string
  representing when the article was published
- `:title` is expected to produce a string containing the article's
  title
- `:tags` is expected to produce a list of acceptable strings suitable
  to be org-mode tags.

**Caveat for Tags:** If you are implementing a `:tags` method for your
news source, be sure to call `(mapcar 'string->tags ...)`.

# Org-mode Tags

We have New York Times related manipulation. The New York Times uses
human readable tags like "Kansas", "Parker, Brett", "Politics and
Government", "State Legislatures", "Brownback, Sam", and "Republican Party".
[Org-mode](http://orgmode.org/manual/Tags.html) however does not allow whitespaces into the tags, so we'll have
to convert these into more suitable versions like `:brett_parker:`
instead of "Parker, Brett", and `:politics_and_government:` instead of
"Politics and Government".

```elisp
(defun nytimes/tags (dom)
  (mapcar 'nytimes.tag/normalize
          (mapcar 'meta-tag/content
                  (dom-elements dom 'property "article:tag"))))
```

For the New York Times, in particular, we need to do quite a bit of
post-processing to transform people's names from `last-name, first-name`
to `first-name last-name`. Fortunately it's fairly well-structured: the
only suffixes they keep track of are "Jr.", "Sr.", and roman numerals.
The sordid details, thoroughly uninteresting, may be found in the
[source code](https://github.com/pqnelson/dsf-news/blob/master/dsf-news.el)

## Generically transforming strings to tags

To transform a given string, like "Donald J. Trump", to an acceptable
org-mode tag, I've written a handly function `string->tag`. It removes
any unacceptable characters (like periods, dashes, etc.), then replaces
whitespace with underscores. Finally it makes the string lower-case (for
consistency). Hence `(string->tag "Donald J. Trump")` produces
`donald_j_trump`.

If you are implementing a `:tags` method for your news source, be sure
to call `(mapcar 'string->tags ...)`.

# How to use this thing?
<a id="quickstart"></a>

**Step 1: "Install" `dsf-news`.**
Simply call `git clone https://github.com/pqnelson/dsf-news` into some
directory where your local emacs can load it. This may require
explicitly adding, e.g., `(load-file "~/src/dsf-news/dsf-news.el")` and
adding a `(require 'dsf-news)` lines in your `~/.emacs` file.

**Step 1.1: Make sure you have dependencies.**
Ubuntu users will run into problems because Ubuntu doesn't package
`dom.el` alongside the other elisp files. So you may have to also
download
[dom.el](https://raw.githubusercontent.com/emacs-mirror/emacs/master/lisp/dom.el).
The other dependencies are pre-loaded in GNU-Emacs 24 (or higher).

**Step 2: Create an org file for the notes.**
I usually keep track of the news in `~/news/news.org`. (Conveniently,
this is where I download the articles as well.)

**Step 3: Start writing.**
You can start writing notes on the news. This amounts to creating new
headlines for each new story, and within a story listing (in
chronological order) the articles on the story. For example:

```
* killer flying robots
- http://www.politico.com/story/2016/12/drones-military-technology-trump-232933
  - Trump will decide how to handle increasingly intelligent autonomous
    killing machines
  - May trigger "killer robot arms race"
* Cartoons
- https://www.washingtonpost.com/lifestyle/the-story-behind-the-sudden-cancellation-of-adult-swims-trump-loving-comedy-show/2016/12/23/ed9e2e3a-c3c8-11e6-8422-eac61c0ef74d_story.html?utm_term=.873331ea8217
  - No new cartoons :(
```

We then "expand the citations" by calling `expand-citations`. This
replaces the raw URLs with org-mode links to the articles, whose
description are the article titles, the source in parenthetics after the
link, then the publication datetime. For our example:


```
* killer flying robots
- [[http://www.politico.com/story/2016/12/drones-military-technology-trump-232933][Killer robots await Trump’s verdict]] (politico.com) <2016-12-25T07:38-0500>
  - Trump will decide how to handle increasingly intelligent autonomous
    killing machines
  - May trigger "killer robot arms race"
* Cartoons
- [[https://www.washingtonpost.com/lifestyle/the-story-behind-the-sudden-cancellation-of-adult-swims-trump-loving-comedy-show/2016/12/23/ed9e2e3a-c3c8-11e6-8422-eac61c0ef74d_story.html][The story behind the sudden cancellation of Adult Swim’s Trump-loving comedy show]] (washingtonpost.com) <2016-12-23T02:34-500>
  - No new cartoons :(
```

**Suggestion 0: Use Wikipedia's Article-Title conventions.**
Wikipedia has put a lot of thought into
[article titles](https://en.wikipedia.org/wiki/Wikipedia:Article_titles)
which seems well-thought, especially regarding [events](https://en.wikipedia.org/wiki/Wikipedia:Naming_conventions_(events)).

**Suggestion 1: Alphabetize the Stories.**
This is what Dr Freeman did, and I tend to agree. Having established a
consistent convention for naming the stories, it's easier to jump to the
location desired.

**Suggestion 2: Inside a story, list the references chronologically.**
The articles will annotate themselves with their publication date, which
makes sorting quick. But by ordering them chronologically, you can
obtain at a glance how the event unfolded.
