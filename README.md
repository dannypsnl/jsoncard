# jsoncard

Convert JSON from stdin to a [forester](https://sr.ht/~jonsterling/forester/) card.

## Install

```shell
opam install -y .
```

## Usage

```shell
scrapy runspider -a url="https://arxiv.org/abs/..." arxiv.py -o -:json | jq '.[]' | jsoncard
```

Python
```py
import scrapy

def remove_prefix(text, prefix):
    return text[text.startswith(prefix) and len(prefix):]

class ArxivSpider(scrapy.Spider):
    name = 'arxivspider'
    allowed_domains = ['arxiv.org']

    def __init__(self, url, *args, **kwargs):
        super(ArxivSpider, self).__init__(*args, **kwargs)
        self.start_urls = [url]

    def parse(self, response):
        dateline = response.xpath('//div[@class="dateline"]/text()').get()
        title = response.xpath('//h1[@class="title mathjax"]/text()').get()
        authors = response.xpath('//div[@class="authors"]/a/text()').getall()
        doi = response.xpath('//td[@class="tablecell arxivdoi"]/a/text()').get()
        abstract = response.xpath('//blockquote[@class="abstract mathjax"]/text()').get()

        yield {
            'date': dateline,
            'title': title,
            'authors': authors,
            'doi': remove_prefix(doi, "https://doi.org/"),
            'abstract': abstract
        }
```
