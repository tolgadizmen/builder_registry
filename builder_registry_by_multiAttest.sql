-- Dune Analytics Query
-- Query ID: 5014174
-- Description: Processes multiAttest transactions (functionSignature = 0x44adc90e) to extract individual attestations
-- Schema: builder_registry

WITH attestation_data AS (
  SELECT
    hash,
    VARBINARY_SUBSTRING(data, CAST(4 + 3 * 32 + 1 AS bigint), 32) AS schemaUid,
    VARBINARY_TO_UINT256(VARBINARY_SUBSTRING(data, CAST(4 + 5 * 32 + 1 AS bigint), 32)) AS numberOfAttestations,
    (VARBINARY_TO_UINT256(VARBINARY_SUBSTRING(data, CAST(4 + 7 * 32 + 1 AS bigint), 32)) - VARBINARY_TO_UINT256(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + 1 AS bigint), 32))) AS attestationLength,
    data
  FROM base.transactions
  WHERE hash IN (
    SELECT attestationHash 
    FROM query_5003067 
    WHERE functionSignature = 0x44adc90e
  )
),
attestation_offsets AS (
  SELECT
    a.*,
    -- Get the offset for each attestation
    VARBINARY_TO_UINT256(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + (n - 1) * 32 + 1 AS bigint), 32)) AS attestation_start_offset,
    n AS attestation_number
  FROM attestation_data a
  CROSS JOIN UNNEST(SEQUENCE(1, TRY_CAST(numberOfAttestations AS BIGINT))) AS t(n)
)
SELECT
  hash,
  schemaUid,
  numberOfAttestations,
  attestationLength,
  attestation_number,
  attestation_start_offset,
  VARBINARY_LTRIM(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + attestation_start_offset + 1 AS bigint), 32)) AS recipient,
  VARBINARY_LTRIM(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + attestation_start_offset + 3 * 32 + 1 AS bigint), 32)) AS referencedAttestation,
  VARBINARY_TO_UINT256(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + attestation_start_offset + 9 * 32 + 1 AS bigint), 32)) AS attestationTextLength,
  FROM_UTF8(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + attestation_start_offset + 10 * 32 + 1 AS bigint), (CAST(VARBINARY_TO_UINT256(VARBINARY_SUBSTRING(data, CAST(4 + 6 * 32 + attestation_start_offset + 9 * 32 + 1 AS bigint), 32)) as bigint)
))) AS attestationText
FROM attestation_offsets
ORDER BY attestation_number 