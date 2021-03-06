# The dbt's Product Warehouse
The dbt product warehouse package provides standard flexible product analytics directly in your data warehouse.

Our goal is to provide a set of models that will allow you to build analytics such as the ones found in SaaS tools. But it will allow more flexibility to go deeper into your data, plus easily join other sources of data for further analysis.

Our ERD so far looks like the following:
![dbt Product Warehouse ERD](dbt_product_warehouse_erd.png)


## Setup
- Add the following to your `packages.yml` file:
```
packages:
  - git: "https://github.com/lantrns-analytics/dbt_product_warehouse.git"
    revision: 0.1 #
```
- You'll need to have the `dbt_utils` package installed, with a version of at least `0.5.0`
- You'll need to provide values for the following variables in your `dbt_project.yml` file
  - `cdp`: CDP used to bring in event data. Default value is `segment`. see Limitations below.
  - `cdp-pages-table`: This points to your raw segment table of pages. Default value is `"{{ source('segment', 'pages') }}"`.
  - `cdp-tracks-table`: This points to your raw segment table of events. Default value is `"{{ source('segment', 'pages') }}"`.
  - `sessions-base-model`: This points to your model of sessions. Default value is `segment_web_sessions`.
- Install the package with `dbt deps`


## What's In The Package
Our package structure follows a `source -> staging -> integration -> warehouses` layering.
Here's what's included in each layer.

### Source
**Location: `staging/product`**

Files:
- `sources.yml` - Configurations to source product event data from Segment.

### Staging
**Location: `staging/product`**

Files:
- `stg_product_pages` - Staging pages viewed by users
- `stg_product_sessions` - Staging user sessions
- `stg_product_tracks` - Staging events triggered by users
- `stg_product_users` - Staging users who interacted with product

### Integration
**Location: `integration/product`
- `int_product_events` - Extracting events from staged data
- `int_product_sessions` - Extracting sessions from staged data
- `int_product_users` - Extracting users from staged data


### Warehouse
**Location: `warehouses/w_product`

Files:
- The package creates a product warehouse which contains the following set of models:
  - `warehouse/w_product/wh_product_events_fact.sql` - Interactions users had with your product
  - `warehouse/w_product/wh_product_sessions_fact.sql` - Sessions on your product by users
  - `warehouse/w_product/wh_product_users_dim.sql` - Users of your product
- In our next iterations of development, we will introduce the following models:
  - `warehouse/w_product/wh_product_attributions_xa.sql` - Conversion events attribution
  - `warehouse/w_product/wh_product_metrics_xa.sql` - Packaged metrics generated on product
  - `warehouse/w_product/wh_product_funnels_xa.sql` - Funnels and paths completed by users

### Our current DAG looks like the following:
![dbt Product Warehouse DAG](dbt_product_warehouse_dag.png)


## Conventions
- As a general rule of thumb, we follow [Fishtown Analytics' dbt Style Guide](https://github.com/fishtown-analytics/corp/blob/master/dbt_coding_conventions.md)
- We use the following keys:
  - `id`: those are natural keys from source systems
  - `pk`: the primary key built within the warehouse
  - `fk`: the foreign key built within the warehouse that allows to join to another entity



## Limitations
- We are only compatible with Segment data for now.
- We currently source session data from [dbt's Segment package](https://github.com/fishtown-analytics/segment)
sessionization transformations. Of course you can use your own sessionization, as long as you provide a model with fields
that conforms to the dbt's Segment package naming standards.
- Functions are Snowflake specific.
