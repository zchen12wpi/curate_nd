# Supporting The Four Pillars of CurateND
CurateND exists to allow scholars to manage and preserve their intellectual output and to facilitate the sharing and discovery of the artifacts of scholarship produced at the University of Notre Dame. CurateND itself is a system of applications and services that endeavor to provide the functionality outlined below n.b. many of these features are incomplete or not present.

## MANAGE
- Be able to describe holdings using arbitrarily granular subject-specific metadata
- Customizable approval and metadata enrichment workflow based on organization or type-specific needs
- Create items in CurateND through:
	- Mediated self deposit
	- Batch ingest of materials of known-good quality
	- Mediated batch ingest of materials
- Update items in CurateND by:
	- making changes to individual records through the web interface
	- making changes to one or more records as a batch process
	- OPTIONAL: making changes to two or more of records through the web interface
- Allow “gated” deposit for some material e.g. undergraduate projects need to have a faculty sponsor in order to deposit their work

### Collaboration
- Grant access to:
	- individuals to view a work or file
	- individuals to edit an existing work or file
	- groups to view a work or file
	- groups to edit an existing work or file
- Allow members of the Notre Dame community to sponsor individuals:
	- with no ND affiliation so they can participate in CurateND without a netID
	- leaving Notre Dame so that they may continue to participate in CurateND without a netID
- Allow individuals to log in using other credentials than their netID:
	- A Notre Dame user could associate their CurateND account with ORCID (or GMail)
	- A sponsored user could associate with other identifiers (i.e. Gmail, ORCID, etc.)
- Allow individuals outside of the Notre Dame community:
	- to view works and files
	- to edit existing work and files
	- to be members of a group

### Versioning Content
- Create separate works in CurateND for each version
- Allow files to have multiple versions
	- Represent multiple expressions and manifestations of a work in a uniform way in CurateND
- OPTIONAL: Support SemVer for software housed in CurateND

## PRESERVE
- Store data and metadata in a digital preservation system
- Perform fixity checking on deposited material
- Migrate established file types to new standards if and when they gain widespread acceptance

## DISCOVER
- Support searching the repository holdings in:
	- CurateND
	- Search engines like Google
	- Specialized search interfaces like Google Scholar
	- OneSearch
- Allow library staff to create thematic or project-based collections of materials  
- Allow patrons to scope their searches:
	- Based on a contributor to a work
	- Based on the affiliation of the work’s creators
	- Based on the administrative unit a work belongs to
	- Based on the topics related to a work
	- To within a collection
	- OPTIONAL: Via bounding box (for geocoded holdings)
- Allow patrons to peruse all the collections:
	- Present in the repository
	- In an administrative unit
	- Associated with a particular topic
	- Associated with a patron affiliation e.g. faculty, staff, student
- Allow patrons to navigate between collections and sub-collections via breadcrumbs
- Perform full-text searches on supported files
- Display records with arbitrarily granular metadata at durable URLs
	- Render previews of common file types

## SHARE
- Create DOIs for:
	- Works
	- Files
	- Versions of Works
	- Versions of Files
- Update DOIs based on metadata changes the corresponding work or file
- Log usage metrics for:
	- Number of page views for a work
	- Number of page views for a file
	- Number of downloads for a file
	- Reject “false” page views and downloads caused by search spiders
- Integrate with an alt-metrics platform such as PlumX
- Syndicate content from CurateND to other platforms:
	- Sitemaps
	- Google Scholar
	- OAI-PMH
	- ResourceSync
	- Honeycomb
	- OPTIONAL: Scalar
- OPTIONAL: Integration with “social” services
	- Facebook Open Graph Protocol
	- twitter cards
	- Rich pins on Pinterest
- OPTIONAL: Provide single-use URLs to grant limited access to a restricted work or file
