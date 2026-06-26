# CloudFront Function — viewer-request handler
#
# Combines language routing (cookie → country → default) with clean-URL
# rewriting (301 for .html paths, index.html injection for extensionless).
# All site-specific config is injected via templatefile() variables so a
# single template serves every site in the fleet.

resource "aws_cloudfront_function" "viewer_request" {
  name    = "${var.name}-${var.environment}"
  runtime = "cloudfront-js-2.0"
  publish = true
  comment = "Language routing + clean-URL rewriting (cloudfront-viewer-request module)"

  code = templatefile("${path.module}/viewer_request.js.tftpl", {
    ip_allowlist_enabled         = var.ip_allowlist_enabled
    allowed_v4_ips_json          = var.allowed_v4_ips_json
    allowed_v6_hex_prefixes_json = var.allowed_v6_hex_prefixes_json
    dev_gate_enabled             = var.dev_access_secret != ""
    dev_access_secret            = var.dev_access_secret
    dev_access_path              = var.dev_access_path
    lang_prefixes_json           = jsonencode(var.lang_prefixes)
    default_lang                 = var.default_lang
    country_to_lang_json         = jsonencode(var.country_to_lang)
    passthrough_exact_json       = jsonencode(var.passthrough_exact)
    passthrough_prefixes_json    = jsonencode(var.passthrough_prefixes)
    cookie_to_prefix_enabled     = length(var.cookie_to_prefix) > 0
    cookie_to_prefix_json        = jsonencode(var.cookie_to_prefix)
    healthz_enabled              = var.healthz_enabled
  })
}
