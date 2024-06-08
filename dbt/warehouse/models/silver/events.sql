select
'hello' as message,
*
from {{ ref('app') }}
