---
name: s3-lifecycle-for-terraform-state
description: Terraform state backend bucket should have lifecycle rules to clean up old versions
metadata:
  type: feedback
---

**Rule:** Any S3 bucket with versioning enabled should have lifecycle rules to clean up old versions after 30 days.

**Why:** If the optional Terraform state backend is configured (currently commented out in backend.tf), versioning must be enabled for safety. Without lifecycle rules, state file versions accumulate indefinitely, causing unnecessary storage costs. A simple 30-day retention prevents accidental deletions while managing costs.

**How to apply:** When setting up the Terraform state backend, add a lifecycle rule that transitions previous versions to GLACIER after 30 days and deletes them after 90 days. Keep current versions in STANDARD.

**Estimated Impact:** Minimal for state-only ($0.10-1/month), but establishes good practice for future buckets.
