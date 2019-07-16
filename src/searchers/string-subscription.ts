import TextStreamAccumulator from "text-stream-accumulator"
import { RejectFunction } from "../types/reject-function.js"
import { ResolveFunction } from "../types/resolve-function.js"
import { Subscription } from "../types/subscription.js"
import { BaseSubscription } from "./base-subscription"

/**
 * StringSubscription calls the given handler exactly one time
 * when text matches the given string.
 */
export class StringSubscription extends BaseSubscription
  implements Subscription {
  searchText: string

  constructor(
    query: string,
    accumulator: TextStreamAccumulator,
    resolve: ResolveFunction,
    reject: RejectFunction,
    timeout?: number
  ) {
    super(accumulator, resolve, reject, timeout)
    this.searchText = query
  }

  /** returns the display name for debug / error messages */
  getDisplayName(): string {
    return `string '${this.searchText}'`
  }

  /**
   * Indicates whether the given text contains the string this subscription is looking for
   * by returning the matching text or null if there are no matches.
   */
  matches(text: string): string | null {
    const found = text.includes(this.searchText)
    if (found) {
      return this.searchText
    } else {
      return null
    }
  }
}
