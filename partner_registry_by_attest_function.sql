-- Dune Analytics Query
-- Query ID: 4954244
-- Description: Fetches partner registry attestations from a specific wallet using the attest function
-- Schema: partner_registry

WITH partnerAttestation AS (
  SELECT
    call_tx_hash,
    call_block_time,
    output_0 as attestationUid
  FROM attestationstation_v1_base.eas_call_attest
  WHERE
    call_tx_from = 0x574d993813e5bab85c7b7761b35c207ad426d9cc AND call_success -- This wallet attests the partners.
    AND TRY_CAST(JSON_EXTRACT(request, '$.schema') AS VARCHAR) = CAST('0x0c25f92df9ba914668f7780e428a1b5238ae7441c765fbe8b7b528f8209ef4e3' AS VARCHAR) --partner attestation schema UID
)

SELECT
  t.hash,
  p.call_block_time,
  p.attestationUid,
  from_utf8(varbinary_substring(t.data, 4 + 13*32 + 1, 32)) AS partner,
  from_utf8(varbinary_substring(t.data, 4 + 15*32 + 1, 32)) AS partnerUrl
FROM base.transactions t
JOIN partnerAttestation p ON t.hash = p.call_tx_hash
ORDER BY partner ASC 