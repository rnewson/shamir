[![Build Status](https://secure.travis-ci.org/rnewson/shamir.png)](http://travis-ci.org/rnewson/shamir)

<h1>Shamir</h1>

<p>
Pure Erlang implementation of Shamir Secret Sharing.
</p>

<h2>Example Usage</h2>
<pre>
1&gt; Shares = shamir:share(&lt;&lt;"hello"&gt;&gt;, 3, 4).
... shares printed here
2&gt; shamir:recover(lists:sublist(Shares, 3).
&lt;&lt;"hello"&gt;&gt;
</pre>
