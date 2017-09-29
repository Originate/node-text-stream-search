require! {
  '../..' : TextStreamSearch
  'chai' : {expect}
  'memory-streams' : {ReadableStream}
  'wait' : {wait}
}


module.exports = ->

  @Given /^a TextStreamSearch instance$/, ->
    @stream = new ReadableStream ''
    @instance = new TextStreamSearch @stream


  @Given /^I tell it to wait for "([^"]*)"$/, (search-term) ->
    (@calls or= {})[search-term] or= 0
    @handler = (@err) ~> @calls[search-term] += 1
    @instance.wait search-term, @handler


  @Given /^I tell it to wait for "([^"]*)" with a timeout of (\d+) milliseconds$/, (search-term, timeout) ->
    (@calls or= {})[search-term] or= 0
    @handler = (@err) ~> @calls[search-term] += 1
    @instance.wait search-term, @handler, parseInt(timeout)


  @Given /^a TextStreamSearch instance with accumulated text$/ ->
    stream = new ReadableStream ''
    @instance = new TextStreamSearch stream
    stream.append "hello world"


  @When /^I tell it to wait for the regular expression "([^"]*)"$/ (search-term) ->
    (@calls or= {})[search-term] or= 0
    @handler = (@err) ~> @calls[search-term] += 1
    @instance.wait new RegExp(search-term), @handler


  @When /^calling 'fullText\(\)' on that instance$/, ->
    @result = @instance.full-text!


  @When /^the stream emits "([^"]*)"$/, (text) ->
    @stream.append text


  @When /^calling the "([^"]*)" method$/ (method-name) ->
    @instance[method-name]!


  @Then /^it returns "([^"]*)"$/, (expected-text) ->
    expect(@result).to.equal expected-text


  @Then /^its accumulated text is empty$/ ->
    expect(@instance.full-text!).to.be.empty


  @Then /^the callback for "([^"]*)" fires(?: only once)?$/, (search-term, done) ->
    wait 1, ~>
      expect(@calls[search-term]).to.equal 1
      expect(@err).to.be.undefined
      done!


  @Then /^the callback for "([^"]*)" does not fire$/, (search-term, done) ->
    wait 1, ~>
      expect(@calls[search-term]).to.equal 0
      done!


  @Then /^the callback for "([^"]*)" does not fire again$/ (search-term, done) ->
    wait 1, ~>
      expect(@calls[search-term]).to.equal 1
      expect(@err).to.be.undefined
      done!


  @Then /^within (\d+) milliseconds the callback for "([^"]*)" fires with the error:$/ (delay, search-term, error-message, done) ->
    wait parseInt(delay), ~>
      expect(@calls[search-term]).to.equal 1
      expect(@err.message).to.eql error-message
      done!


  @Then /^within (\d+) milliseconds the callback for "([^"]*)" has not fired again$/ (delay, search-term, done) ->
    wait parseInt(delay), ~>
      expect(@calls[search-term]).to.equal 1
      expect(@err).to.be.undefined
      done!
