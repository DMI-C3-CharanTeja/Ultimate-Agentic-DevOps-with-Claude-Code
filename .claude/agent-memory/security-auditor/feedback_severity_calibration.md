---
name: feedback-terraform-static-site-severity-calibration
description: How to calibrate CRITICAL/HIGH/MEDIUM/LOW severity for a public static-site stack with no secrets/PII
metadata:
  type: feedback
---

For the portfolio-site stack (public static HTML/CSS content, no user data, no secrets, no
IAM resources), calibrate severity relative to blast radius, not just checklist presence:

- Missing encryption-at-rest on an S3 bucket that only serves already-public static assets is
  MEDIUM, not HIGH/CRITICAL — the data has no confidentiality requirement since it's served
  publicly via CloudFront anyway. Still flag it (compliance/defense-in-depth), just don't
  overstate it.
- Missing logging (S3 access logs, CloudFront logs) is MEDIUM — it's an audit/forensics gap,
  not an active exposure.
- Missing security response headers (CSP, X-Frame-Options, HSTS) is MEDIUM since this is a
  public-facing site (clickjacking/XSS-adjacent defense-in-depth), even though there's no
  JavaScript per CLAUDE.md conventions.
- Reserve HIGH/CRITICAL for things with real exposure: public S3 write access, wildcard IAM on
  a real role, long-lived AWS credentials in a CI pipeline, hardcoded secrets/ARNs/account IDs,
  or a broken confused-deputy bucket policy.
- Local/unconfigured Terraform state backend jumps from LOW to MEDIUM/HIGH specifically when
  CI/CD (e.g., GitHub Actions per CLAUDE.md) is stated to run `terraform apply` automatically,
  because unlocked concurrent applies and no encrypted shared state become an operational and
  audit-trail risk, not just a hygiene nit.

Why: avoids crying wolf on a low-stakes static site while still keeping compliance-style
findings visible; keeps severity meaningful so real findings on other repos with actual
IAM/secrets stand out.

How to apply: use this scale when auditing any low-sensitivity static site stack in this repo
family; re-evaluate if the site ever starts handling user data, forms, or auth.
