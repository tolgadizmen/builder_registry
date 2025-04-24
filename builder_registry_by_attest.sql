-- Dune Analytics Query
-- Query ID: 4986543
-- Description: Processes attest transactions (functionSignature = 0xf17325e7) to extract individual attestations
-- Schema: builder_registry

SELECT
  hash as attestationHash,
  VARBINARY_SUBSTRING(data, 4 + 32 + 1, 32) AS schemaUid,
  VARBINARY_LTRIM(VARBINARY_SUBSTRING(data, 4 + 3 * 32 + 1, 32)) AS recipient,
  VARBINARY_SUBSTRING(data, 4 + 6 * 32 + 1, 32) AS referencedAttestation,
  from_utf8(varbinary_substring(data, 4 + 13*32 + 1, 64)) AS attestationText
FROM base.transactions
WHERE hash IN (
  SELECT attestationHash 
  FROM query_5003067 
  WHERE functionSignature = 0xf17325e7)
ORDER BY hash 