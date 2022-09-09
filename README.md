# `dbt-metrics-oracle`

Built in the image of exellent example -> [tsql-metrics](https://github.com/dbt-msft/tsql-metrics)

This [dbt](https://github.com/fishtown-analytics/dbt) package contains macros 
that extend use of dbt-metrics to Oracle databases

## Compatibility

This package provides "shims" for:
- [dbt-metrics](https://github.com/fishtown-analytics/metrics) (partial)

## Usage

`{{metrics.<ported-macro>(<arg>)}}` 


## Installation Instructions

1. Install dbt-metrics
Add following to your packages.yaml file.
    ```yaml
    packages:
      - package: dbt-labs/metrics 
        version: check [dbt hub](https://hub.getdbt.com/) for latest version

Check [dbt-metrics](https://github.com/fishtown-analytics/metrics) for latest installation instructions

2. Install `dbt-metrics-oracle`
    ```yaml
    packages:
      - package: algol68/dbt_metrics_oracle
        version: {SEE PROJECT HUB FOR NEWEST VERSION}
    ```
3. add dbt-metrics-oracle as macro provider for dbt-metrics
    ```yaml
    dispatch:
      - macro_namespace: metrics
        search_order: ['dbt_oracle_metrics', 'metrics']
    ```

