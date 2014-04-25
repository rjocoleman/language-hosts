describe "Hosts file grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-hosts")

    runs ->
      grammar = atom.syntax.grammarForScopeName("source.hosts")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.hosts"

  it "tokenizes comments", ->
    {tokens} = grammar.tokenizeLine("# 127.0.0.1 example.com")
    expect(tokens[0]).toEqual value: "# 127.0.0.1 example.com", scopes: ["source.hosts", "comment.line.hosts"]

  it "tokenizes fqdn", ->
    {tokens} = grammar.tokenizeLine("example.com")
    expect(tokens[0]).toEqual value: "example.com", scopes: ["source.hosts", "string.unquoted.domain.hosts"]

    {tokens} = grammar.tokenizeLine("www.example.net")
    expect(tokens[0]).toEqual value: "www.example.net", scopes: ["source.hosts", "string.unquoted.domain.hosts"]

    {tokens} = grammar.tokenizeLine("invalid")
    expect(tokens[0]).toNotEqual value: "invalid", scopes: ["source.hosts", "string.unquoted.domain.hosts"]

  it "tokenizes ipv4", ->
    {tokens} = grammar.tokenizeLine("127.0.0.1")
    expect(tokens[0]).toEqual value: "127.0.0.1", scopes: ["source.hosts", "constant.numeric.ipv4.hosts"]

    {tokens} = grammar.tokenizeLine("999.999.999.999")
    expect(tokens[0]).toNotEqual value: "999.999.999.999", scopes: ["source.hosts", "constant.numeric.ipv4.hosts"]

    {tokens} = grammar.tokenizeLine("254.21.78.109")
    expect(tokens[0]).toEqual value: "254.21.78.109", scopes: ["source.hosts", "constant.numeric.ipv4.hosts"]

    {tokens} = grammar.tokenizeLine("invalid")
    expect(tokens[0]).toNotEqual value: "invalid", scopes: ["source.hosts", "constant.numeric.ipv4.hosts"]

  it "tokenizes ipv6", ->
    {tokens} = grammar.tokenizeLine("::1")
    expect(tokens[0]).toEqual value: "::1", scopes: ["source.hosts", "constant.numeric.ipv6.hosts"]

    {tokens} = grammar.tokenizeLine("::7777:8888")
    expect(tokens[0]).toEqual value: "::7777:8888", scopes: ["source.hosts", "constant.numeric.ipv6.hosts"]

    {tokens} = grammar.tokenizeLine("invalid")
    expect(tokens[0]).toNotEqual value: "invalid", scopes: ["source.hosts", "constant.numeric.ipv6.hosts"]
