---
name: cloudfront-price-class-optimization
description: Portfolio site uses PriceClass_200 but PriceClass_100 would be significantly cheaper for low-traffic static site
metadata:
  type: feedback
---

**Rule:** Static portfolio websites should use PriceClass_100 unless traffic is globally distributed.

**Why:** PriceClass_200 includes ~200 edge locations globally, but for a personal portfolio with concentrated traffic (likely single region or developed countries), PriceClass_100's ~100 locations in developed countries is sufficient. This reduces CloudFront data transfer costs by 30-50%.

**How to apply:** Change `price_class = "PriceClass_200"` to `price_class = "PriceClass_100"` in CloudFront distribution. Measure performance metrics for 1-2 weeks; if latency remains acceptable, keep the optimization. If you later add global traffic, revert to PriceClass_200.

**Estimated Impact:** $2-10/month savings depending on current traffic volume. For a low-traffic site (~1-5GB/month), savings could be $5-15/month.
