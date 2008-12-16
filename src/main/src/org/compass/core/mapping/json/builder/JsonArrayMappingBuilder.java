/*
 * Copyright 2004-2008 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.compass.core.mapping.json.builder;

import org.compass.core.engine.naming.StaticPropertyPath;
import org.compass.core.mapping.json.JsonArrayMapping;

/**
 * @author kimchy
 */
public class JsonArrayMappingBuilder {

    final JsonArrayMapping mapping;

    public JsonArrayMappingBuilder(JsonArrayMapping mapping) {
        this.mapping = mapping;
    }

    public JsonArrayMappingBuilder indexName(String indexName) {
        mapping.setPath(new StaticPropertyPath(indexName));
        return this;
    }

    public JsonArrayMappingBuilder dynamic(boolean dynamic) {
        mapping.setDynamic(dynamic);
        return this;
    }

    public JsonArrayMappingBuilder element(JsonPropertyMappingBuilder builder) {
        if (builder.mapping.getName() == null) {
            builder.mapping.setName(mapping.getName());
        }
        if (builder.mapping.getPath() == null) {
            builder.mapping.setPath(mapping.getPath());
        }
        mapping.setElementMapping(builder.mapping);
        return this;
    }

    public JsonArrayMappingBuilder set(PlainJsonObjectMappingBuilder builder) {
        if (builder.mapping.getName() == null) {
            builder.mapping.setName(mapping.getName());
        }
        if (builder.mapping.getPath() == null) {
            builder.mapping.setPath(mapping.getPath());
        }
        mapping.setElementMapping(builder.mapping);
        return this;
    }

    public JsonArrayMappingBuilder set(JsonArrayMappingBuilder builder) {
        if (builder.mapping.getName() == null) {
            builder.mapping.setName(mapping.getName());
        }
        if (builder.mapping.getPath() == null) {
            builder.mapping.setPath(mapping.getPath());
        }
        mapping.setElementMapping(builder.mapping);
        return this;
    }
}
