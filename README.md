# Introduction
The dbt product warehouse package provides standard flexbile product analytics directly in your data warehouse.

By sourcing event data streaming from services such as Segment, we materialize the 4 following set of models:
- Users
- Events
- Funnels
- Metrics

Those models should allow you to build analytics such as the ones found in SaaS tools such as Amplitude, Mixpanel and Heap. But it also provides a lot of flexibility to go deeper into your data, plus easily join other sources of data for further analysis.
