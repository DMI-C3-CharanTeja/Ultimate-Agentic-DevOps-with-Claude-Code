---
name: project-portfolio-site-stack
description: Architecture and known security gaps of the portfolio-site Terraform stack (S3+CloudFront), as of first audit 2026-07-12
metadata:
  type: project
---

The `terraform/` directory provisions a static portfolio website: one `aws_s3_bucket` (private,
OAC-fronted), `aws_s3_bucket_public_access_block`, `aws_cloudfront_origin_access_control` (OAC,
not legacy OAI — correct), `aws_s3_bucket_policy` scoped via `AWS:SourceArn` condition to the
specific distribution (confused-deputy protected — correct), and one `aws_cloudfront_distribution`.
There are no IAM role/policy resources, no security groups, and no databases in this repo's
Terraform at all — checklist items about IAM wildcards/least-privilege are consistently N/A here
until an OIDC deploy role is added.

As of the 2026-07-12 audit, the stack already does several things right: public access fully
blocked, OAC (not OAI) used, bucket policy scoped by SourceArn, viewer_protocol_policy is
redirect-to-https, allowed_methods limited to GET/HEAD, account ID is pulled dynamically via
`data.aws_caller_identity.current` (never hardcoded).

Recurring gaps found (worth checking first on every re-audit of this repo):
- No `aws_s3_bucket_server_side_encryption_configuration` on the website bucket.
- No `aws_s3_bucket_versioning` on the website bucket.
- No CloudFront `logging_config` block and no S3 access logging — no log bucket exists at all.
- No `aws_cloudfront_response_headers_policy` — CSP/X-Frame-Options/HSTS/X-Content-Type-Options
  are all missing from checklist requirement.
- No AWS WAF (`aws_wafv2_web_acl`) associated with the CloudFront distribution.
- `backend.tf` ships only as commented-out instructions; state is local. CLAUDE.md says
  deploys are automated via GitHub Actions, so a local/unshared, unlocked, unencrypted backend
  is a real risk once CI starts running `terraform apply` (state races, no audit trail).
- `variable "domain_name"` is declared but never wired into the distribution (no `aliases`,
  no ACM cert, no `minimum_protocol_version`) — dead code today, but if someone adds a custom
  domain later without also setting `minimum_protocol_version = "TLSv1.2_2021"` and
  `ssl_support_method = "sni-only"`, that would regress TLS security.
- No IAM/OIDC resources exist for GitHub Actions despite CLAUDE.md stating deploys are
  automated via GitHub Actions — worth asking the user each audit whether CI currently uses
  long-lived AWS access keys (should migrate to `aws_iam_openid_connect_provider` + a role
  trust-scoped to the specific repo/branch) since that isn't visible from this repo's
  `.github/workflows/` (none currently exist in-repo).

How to apply: on future audits of this repo, check first whether any of the above gaps have
been fixed, and treat unresolved ones as already-known findings rather than rediscovering from
scratch. See [[feedback-terraform-static-site-severity-calibration]] for how severity was
calibrated for a public, non-sensitive static site.
