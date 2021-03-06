/**
 * SimpleReadableStream describes the API that this library uses
 * on the streams it consumes.
 */
export interface SimpleReadableStream {
  on(eventName: string, cb: (data: Buffer) => void): void
}
