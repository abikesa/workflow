# Part 1: Dionysus


> *Call option price is analogous to the difference between the `base-case` & `clinical-scenario`; i.e., `logHR`. In clinical medicine, we've kept our cumulative distribution functions non-parametric, at least for our base-case (62,000 citations: [Google Scholar](https://scholar.google.com/scholar?hl=en&as_sdt=0%2C21&q=Regression+Models+and+Life-Tables.%22&btnG=))*

  <iframe src="./cox.pdf" height="100px" width="100%" style="borders:none"></iframe>


$$
C(S, t) = S_0 \mathcal{N}(d_1) - X e^{-r(T-t)} \mathcal{N}(d_2)
$$

where:

$$
d_1 = \frac{\ln(S_0/X) + (r + \sigma^2/2)(T-t)}{\sigma \sqrt{T-t}}
$$

$$
d_2 = d_1 - \sigma \sqrt{T-t}
$$

Here, $C$ is the call option price, $S_0$ is the current stock price, $X$ is the strike price, $r$ is the risk-free interest rate, $T$ is the time to maturity, $\sigma$ is the volatility of the stock, and $\mathcal{N}(\cdot)$ is the cumulative distribution function of the standard normal distribution.





           1. Chaos
                   \
      2. Frenzy -> 4. Unpredictable -> 5. Algorithm -> 6. Binary
                   / 
                   3. Random-Walk



<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto;">
  <iframe src="https://www.youtube.com/embed/A5w-dEgIU1M?start=1" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
</div>

## `Efficient-Market Hypothesis`

### Null 1, 2, 3
- `Voir`: Random brownian motion as seen in digital information from Bloomberg Terminal; $\text{H}_0:$ `logHR=0`
- `Savoir`: Compute may find patterns than Eugene Fama's mind couldn't
- `Pouvoir`: $\mu | \text{X}\beta$ ; $\sigma | t$; two overlayed multivariable _Kaplan-Meier's_

### Sing O Muse 4
- `Unpredictable`: Estimates **conditional** on factors millions of orders of magnitude more than human mind "tameth"; no wonder there's been **gnashing of teeth**

### Alternative 5, 6
- `Identity`: Some quants, programmers, and algorithms have produced better returns than the null-hypothesis over decades
- `Achievements`: Using super-human `AI` capabilities of machines to handle $N^N$ **parameters**, [Jim Simmons](https://en.wikipedia.org/wiki/Jim_Simons#Controversies) is the best way to summarize this

#### Table of Contents

```{tableofcontents}
```



