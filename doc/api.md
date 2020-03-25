# CurateND API

CurateND has a REST API that you can use to search, download, and upload content.

## Getting Started

# Examples

This section gives a few examples of interacting and doing simple things with the CurateND API.

## Get a file

If you know the id of the file you want, you can download it by using the download endpoint. The `-O` option saves this to the file `1n79h41832s`.

~~~sh
$ curl -O https://curate.nd.edu/api/items/download/1n79h41832s
~~~

## Do a Search

This searches for "aristotle sculpture" and returns the first 10 results.

~~~sh
$ curl "https://curate.nd.edu/api/items?q=aristotle+sculpture"
{
  "query": {
    "queryUrl": "https://curate.nd.edu/api/items?q=aristotle+sculpture",
    "queryParameters": {
      "q": "aristotle sculpture"
    }
  },
  "results": [
    {
      "id": "1j92g734t1t",
      "title": "Lyon Cathedral: Interior detail, sculpture fragment on display, illustrating the exemplum of Phyllis and Aristotle",
      "type": "Image",
      "itemUrl": "https://curate.nd.edu/api/items/1j92g734t1t"
    }
  ],
  "pagination": {
    "itemsPerPage": 12,
    "totalResults": 1,
    "currentPage": 1,
    "firstPage": "https://curate.nd.edu/api/items?q=aristotle+sculpture",
    "lastPage": "https://curate.nd.edu/api/items?q=aristotle+sculpture"
  }
}
~~~

To get more information for the result, use the `itemUrl` link.
You will get a JSON object containing the metadata for item `1j92g734t1t` and a list of all
the files attached to it in the `containedFiles` key.
Each file has a key `downloadUrl` that gives a link to use for downloading the contents of the file.

~~~sh
$ curl https://curate.nd.edu/api/items/1j92g734t1t
{
  "requestUrl": "https://curate.nd.edu/api/items/1j92g734t1t",
  "id": "1j92g734t1t",
  "rights": "https://creativecommons.org/licenses/by-nc-nd/4.0/",
  "dateSubmitted": "2017-06-30Z",
  "creator#administrative_unit": "University of Notre Dame::Hesburgh Libraries::General",
  "description": "The cathedral is famous for the 325 reliefs decorating the embrasures of the west portals, which date from the episcopate (1308–22) of Pierre de Savoie. The reliefs representing frolicking lovers from the Lai d'Aristote are remarkable for their subtle modelling and the composition of the figures in relation to the frame.\n\nThe cathedral was rebuilt from 1170 to 1180 by Bishop Guichard. The conservatism of the canons is apparent in such archaisms as a bench for the clergy round the inside of the apse; in the very traditional plan (a seven-sided polygonal apse leading out of a straight-ended choir, with squared-off side chapels); and in the style, which is still Romanesque, with blind arcading, fluted pilasters in the triforium, and triple windows in the straight bays. The Gothic style first appears in the transept (with pointed arches in the triforium). The chapel of the Bourbons, built in the second half of the 15th century on the south side of the nave, is the most beautiful example of Flamboyant in the Lyonnais.",
  "placeOfCreation": "+45.760556+4.8275",
  "creator": "G. Massiot & cie",
  "subject": "Cathedrals",
  "temporal": "before or circa 1910",
  "alternative": "Cathédrale Saint-Jean-Baptiste de Lyon",
  "title": "Lyon Cathedral: Interior detail, sculpture fragment on display, illustrating the exemplum of Phyllis and Aristotle",
  "created": "1910-01-01",
  "modified": "2017-06-30Z",
  "culturalContext": "Gothic (Medieval)",
  "date#digitized": "2007-01-01",
  "access": {
    "readGroup": [
      "public"
    ],
    "editPerson": [
      "rtillman"
    ]
  },
  "depositor": "batch_ingest",
  "owner": "rtillman",
  "representative": "https://curate.nd.edu/api/items/download/1n79h41832s",
  "bendoItem": "kp78gf0997k",
  "hasModel": "Image",
  "isMemberOfCollection": [
    "https://curate.nd.edu/api/items/r207tm73k88"
  ],
  "containedFiles": [
    {
      "id": "1n79h41832s",
      "fileUrl": "https://curate.nd.edu/api/items/1n79h41832s",
      "downloadUrl": "https://curate.nd.edu/api/items/download/1n79h41832s",
      "thumbnailUrl": "https://curate.nd.edu/api/items/download/1n79h41832s/thumbnail",
      "characterization": "<fits ...>...</fits>",
      "bendoItem": "kp78gf0997k",
      "dateSubmitted": "2017-06-30Z",
      "title": "France-Lyons-cathedral-S-John-int.jpg",
      "modified": "2017-06-30Z",
      "label": "France-Lyons-cathedral-S-John-int.jpg",
      "mimeType": "image/jpeg",
      "access": {
        "readGroup": [
          "public"
        ],
        "editPerson": [
          "rtillman"
        ]
      },
      "depositor": "batch_ingest",
      "owner": "rtillman",
      "hasModel": "GenericFile",
      "isPartOf": [
        "https://curate.nd.edu/api/items/1j92g734t1t"
      ]
    },
    {
      "id": "1r66j101c3p",
      "fileUrl": "https://curate.nd.edu/api/items/1r66j101c3p",
      "downloadUrl": "https://curate.nd.edu/api/items/download/1r66j101c3p",
      "thumbnailUrl": "https://curate.nd.edu/api/items/download/1r66j101c3p/thumbnail",
      "characterization": "<fits ...>...</fits>",
      "bendoItem": "kp78gf0997k",
      "dateSubmitted": "2017-06-30Z",
      "title": "image_2074.xml",
      "modified": "2017-06-30Z",
      "label": "image_2074.xml",
      "mimeType": "application/xml",
      "access": {
        "readGroup": [
          "public"
        ],
        "editPerson": [
          "rtillman"
        ]
      },
      "depositor": "batch_ingest",
      "owner": "rtillman",
      "hasModel": "GenericFile",
      "isPartOf": [
        "https://curate.nd.edu/api/items/1j92g734t1t"
      ]
    },
    {
      "id": "1v53jw84n44",
      "fileUrl": "https://curate.nd.edu/api/items/1v53jw84n44",
      "downloadUrl": "https://curate.nd.edu/api/items/download/1v53jw84n44",
      "thumbnailUrl": "https://curate.nd.edu/api/items/download/1v53jw84n44/thumbnail",
      "characterization": "<fits ...>...</fits>",
      "bendoItem": "kp78gf0997k",
      "dateSubmitted": "2017-06-30Z",
      "title": "France-Lyons-cathedral-S-John-int.tif",
      "modified": "2017-06-30Z",
      "label": "France-Lyons-cathedral-S-John-int.tif",
      "mimeType": "image/tiff",
      "access": {
        "readGroup": [
          "public"
        ],
        "editPerson": [
          "rtillman"
        ]
      },
      "depositor": "batch_ingest",
      "owner": "rtillman",
      "hasModel": "GenericFile",
      "isPartOf": [
        "https://curate.nd.edu/api/items/1j92g734t1t"
      ]
    }
  ]
}
~~~

## Upload a file




# Reference

## Data Model

CurateND represents deposits as a graph of _objects_.
There is an object to represent the deposit as a whole, as well as additional objects for each individual file.
There can be deposit objects with no files as well.
(Although the converse is not true—every file object is associated with a deposit object).
The deposit object is also called the _item's record_ since most of the metadata for a deposit is stored in that object.

Every object is identified with a _CurateND Identifier_.
This identifier will have the form `und:xxxxxxxxxxx` where the Xs are either numerals or lowercase letters.
Sometimes the `und:` prefix may be missing if it is understood by the context that it is a CurateND Identifier.
In what follows we call these identifiers PIDs, for persistent identifiers.

In addition to the record objects and the file objects, you may also encounter _collection objects_.
These represent larger groups of items, and a collection may even contain other collections.

Every object has an _access level_ that governs who can view or update the object.
By default every object is private and cannot be viewed or changed by anyone.
Access to specific people or groups can be given explicitly.
There are also two special groups: `registered` which includes everyone who is logged in to the system,
and `public` which is everyone accessing the system whether logged in or not.

## Metadata Fields

## Authentication

While you can use the API unauthenticated, you will only have access to `Public` items, and you cannot create any works or deposit any files.
Additionally, all the unauthenticated requests share the same rate-limiting bucket, so the resulting performance is dependent on who else is using the API.

Any valid user account (that is, every valid Notre Dame Netid) can get a unique token to use with the API.
Your client should then pass this token to the API using the `X-Api-Token` header.
For example, if I had the token `ABCD12345` I would pass this token using curl as follows.

~~~sh
curl -H "x-api-token: ABCD12345" https://curate.nd.edu/api/items
~~~

### [how to get token]


## Endpoints

General information on using endpoints.
Error codes.
200 -
403 -
401 -
4?? - getting from tape
500 -

Headers.

### Item information

```
/api/items/:id
```

### Item Download

```
/api/items/download/:id
```

### Search

### Create time-limited access link

### Upload

