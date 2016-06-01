## Controls for files
- ~~Download~~ Cache status:
	- “Download” (default; green badge?)
	- “Request Retrieval” (AJAX-assigned; yellow badge?)
- View details
- Access badge (realign)
- ~~Edit~~ (Move to File details)
- ~~Rollback~~ (Move to File details)
- ~~Delete~~ (Move to File details)
- Grant One-time Access (ETD)
- Access request notice (ETD)
- Send a request instructions (ETD)

## File Details
- [x] Change button theme
- [x] Move to multi-column layout with thumbnail on the left and details on the right
- [x] Add Rollback button
- [x] ~~Add breadcrumb with File and Item~~ Included parent as attribute instead
- [x] ~~Move the “Back to…” button to its own line (arrow button?)~~ Removed

## File Cache Checking
- [x] Toggle button state based on cache status
- [x] Display file access notice based on cache status
- [ ] Toggle access URLs based on cache status
- [ ] Implement API calls to Bendo
- [ ] Implement “retrieval” behavior
	- [ ] Display notice on placeholder page
	- [ ] Display file size (based on FITS on placeholder page)
	- [ ] Call Bendo API to recall item
	- [ ] Implement cache status poller that will redirect to the download URL when finished