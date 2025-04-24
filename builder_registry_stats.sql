-- Dune Analytics Query
-- Query ID: 5016671
-- Description: Provides statistics about partner verifications, including total number of recipients and unique recipients per partner.
-- Schema: builder_registry

SELECT 
  partner,
  count(recipient) as numberOfRecipients,
  count(distinct recipient) as numberOfUniqueRecipients
FROM query_5016644
GROUP BY partner
ORDER BY partner ASC 