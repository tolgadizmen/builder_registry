-- Dune Analytics Query
-- Query ID: 5016574
-- Description: Joins builder registry attestations (from attest function) with partner verifications. 
-- Shows which builders are verified by which partners by matching referencedAttestation with partner attestationUid.
-- Includes partner name and URL for verified builders.
-- Schema: builder_registry

WITH source_attestations AS (
  SELECT 
    attestationHash,
    attestationUid,
    recipient
  FROM query_5003067
  WHERE functionSignature = 0xf17325e7
),
processed_attestations AS (
  SELECT 
    attestationHash,
    recipient,
    referencedAttestation,
    attestationText
  FROM query_4986543
),
partner_verifications AS (
  SELECT
    hash,
    attestationUid,
    partner,
    partnerUrl
  FROM query_4954244
)
SELECT 
  s.attestationHash,
  s.attestationUid,
  s.recipient,
  p.referencedAttestation,
  p.attestationText,
  pv.partner,
  pv.partnerUrl
FROM source_attestations s
JOIN processed_attestations p 
  ON s.attestationHash = p.attestationHash 
  AND s.recipient = p.recipient
LEFT JOIN partner_verifications pv
  ON p.referencedAttestation = pv.attestationUid
ORDER BY s.attestationHash 