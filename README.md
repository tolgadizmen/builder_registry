# Builder Registry Queries

## Query Descriptions

### builder_registry_with_functionSignature
- Query ID: 5003067
- Description: Fetches builder registry transactions with their function signatures, filtering for a specific schema and excluding revoked attestations

### builder_registry_by_multiAttest
- Query ID: 5014174
- Description: Processes multiAttest transactions (functionSignature = 0x44adc90e) to extract individual attestations

### builder_registry_by_attest
- Query ID: 4986543
- Description: Processes attest transactions (functionSignature = 0xf17325e7) to extract individual attestations

### builder_registry_by_attest_joined
- Query ID: 5016574
- Description: Joins builder registry attestations (from attest function) with partner verifications. Shows which builders are verified by which partners by matching referencedAttestation with partner attestationUid. Includes partner name and URL for verified builders.

### builder_registry_by_multiAttest_joined
- Query ID: 5015892
- Description: Joins builder registry attestations (from multiAttest function) with partner verifications. Shows which builders are verified by which partners by matching referencedAttestation with partner attestationUid. Includes partner name and URL for verified builders.

### builder_registry_all
- Query ID: 5016644
- Description: Combines all builder registry attestations from both attest and multiAttest functions into a single table. Includes attestation details, recipient information, and partner verifications.

### builder_registry_stats
- Query ID: 5016671
- Description: Provides statistics about partner verifications, including total number of recipients and unique recipients per partner.

### partner_registry_by_attest_function
- Query ID: 4954244
- Description: Fetches partner registry attestations from a specific wallet using the attest function

## Schemas and Tables

### Attester Wallet
- Address: 0x574d993813e5bab85c7b7761b35c207ad426d9cc
- Functions:
  - Attests partners
  - Verification wallet for Talent Protocol (one of the partners)

### Schemas

#### Schema 1 (#597) - Partner Registry
- Schema UID: 0x0c25f92df9ba914668f7780e428a1b5238ae7441c765fbe8b7b528f8209ef4e3
- EAS Scan URL: https://base.easscan.org/schema/view/0x0c25f92df9ba914668f7780e428a1b5238ae7441c765fbe8b7b528f8209ef4e3

#### Schema 2 (#598) - Builder Registry
- Schema UID: 0x597905068aedcde4321ceaf2c42e24d3bbe0af694159bececd686bf057ec7ea5
- EAS Scan URL: https://base.easscan.org/schema/view/0x597905068aedcde4321ceaf2c42e24d3bbe0af694159bececd686bf057ec7ea5

### Tables

#### attestationstation_v1_base.eas_call_attest
| name | type |
| --- | --- |
| contract_address | varbinary |
| call_success | boolean |
| call_tx_hash | varbinary |
| call_tx_from | varbinary |
| call_tx_to | varbinary |
| call_tx_index | integer |
| call_trace_address | array(bigint) |
| call_block_time | timestamp |
| call_block_number | bigint |
| call_block_date | date |
| output_0 | varbinary |
| request | varchar |

#### attestationstation_v1_base.eas_call_multiattest
| name | type |
| --- | --- |
| contract_address | varbinary |
| call_success | boolean |
| call_tx_hash | varbinary |
| call_tx_from | varbinary |
| call_tx_to | varbinary |
| call_tx_index | integer |
| call_trace_address | array(bigint) |
| call_block_time | timestamp |
| call_block_number | bigint |
| call_block_date | date |
| multiRequests | array(varchar) |
| output_0 | array(varbinary) | 