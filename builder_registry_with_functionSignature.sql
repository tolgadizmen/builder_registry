-- Dune Analytics Query
-- Query ID: 5003067
-- Description: Fetches builder registry transactions with their function signatures, filtering for a specific schema and excluding revoked attestations
-- Schema: builder_registry

WITH filtered_attestations AS (
  SELECT 
    a.evt_tx_hash as attestationHash,
    a.uid as attestationUid,
    a.schema as schemaUid,
    a.recipient,
    a.attester
  FROM attestationstation_v1_base.eas_evt_attested a
  WHERE a.schema = 0x597905068aedcde4321ceaf2c42e24d3bbe0af694159bececd686bf057ec7ea5
  AND NOT EXISTS (
    SELECT 1
    FROM attestationstation_v1_base.eas_evt_revoked r
    WHERE r.uid = a.uid AND r.schema = a.schema
  )
),
tx_hashes AS (
  SELECT DISTINCT attestationHash
  FROM filtered_attestations
)
SELECT 
  a.*,
  VARBINARY_SUBSTRING(t.data, 1, 4) AS functionSignature
FROM filtered_attestations a
JOIN (
  SELECT hash, data 
  FROM base.transactions
  WHERE hash IN (SELECT attestationHash FROM tx_hashes)
) t ON a.attestationHash = t.hash 