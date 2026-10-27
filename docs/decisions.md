## Questions for the owner

### Question 1:
Can more than one mechanic work on the same repair?

Assumption:
We assume that each repair has one assigned mechanic.

If the answer is different:
If multiple mechanics can work on the same repair, the id_mechanic field would be removed from Repair and a new Repair_mechanic table would be added to represent the many-to-many relationship between repairs and mechanics.

### Question 2:
Can the same service be performed more than once during a single repair?

Assumption:
We assume that each service can only appear once per repair.

If the answer is different:
Repair_service could not use (id_repair, id_service) as its composite primary key. It would need its own identifier, such as id_repair_service, to allow the same service to appear multiple times.

### Question 3:
Can the promised completion date be changed after it has been given to the customer?

Assumption:
We assume that the promised date can be updated if the repair is delayed.

If the answer is different:
If the original promised date must never change, the model would need to preserve the original date separately from any revised completion date.

## Default account role

The default account role is `mechanic`.

Mechanic was chosen because it has the fewest permissions in the workshop. Mechanics need access to the workshop information required to inspect and work on repairs, while counter staff handle customer and repair intake information, and the owner has the broadest administrative responsibilities.

Using the least-privileged role as the default also ensures that accounts created through public sign-up do not receive additional privileges unless their role is explicitly changed through the seed or Rails console.