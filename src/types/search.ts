/**
 * Search represents a request from somebody (the requester of the search)
 * to find a match for search query (string or regex) in the text stream.
 * Once the query is found, the search is over and the identified match is returned to the caller.
 * A search can have a timeout after which it is aborted.
 */
export interface Search {
  /**
   * Scan signals to this search that there is new text to look through.
   */
  scan(): void
}
