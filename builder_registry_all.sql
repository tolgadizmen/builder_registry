-- Dune Analytics Query
-- Query ID: 5016644
-- Description: Combines all builder registry attestations from both attest and multiAttest functions into a single table. 
-- Includes attestation details, recipient information, and partner verifications.
-- Schema: builder_registry

WITH attest_attestations AS (
  SELECT 
    attestationHash,
    attestationUid,
    recipient,
    partner,
    partnerUrl,
    attestationText
  FROM query_5016574
),
multiattest_attestations AS (
  SELECT 
    attestationHash,
    attestationUid,
    recipient,
    partner,
    partnerUrl,
    attestationText
  FROM query_5015892
)
SELECT 
  attestationHash,
  attestationUid,
  recipient,
  partner,
  partnerUrl,
  attestationText
FROM attest_attestations
UNION ALL
SELECT 
  attestationHash,
  attestationUid,
  recipient,
  partner,
  partnerUrl,
  attestationText
FROM multiattest_attestations
ORDER BY attestationHash 