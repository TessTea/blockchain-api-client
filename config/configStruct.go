package config

type Config struct {
	App App `yaml:"app"`
	// Kafka    Kafka    `yaml:"kafka"`
	// Postgres Postgres `yaml:"postgres"`
	Polygon Polygon `yaml:"polygon"`
}

type App struct {
	// Versions    map[string]uint `yaml:"versions"`
	// Environment string          `yaml:"environment"`
	Host string `yaml:"host"`
	Port int    `yaml:"port"`
}

type Polygon struct {
	Url string `yaml:"url"`
}

// type Kafka struct {
// 	Host              string `yaml:"host"`
// 	Prefix            string `yaml:"prefix"`
// 	ConsumerGroup     string `yaml:"consumergroup"`
// 	ReplicationFactor int    `yaml:"replicationfactor"`
// 	Partitions        int    `yaml:"partitions"`
// }

// type Postgres struct {
// 	Host     string `yaml:"host"`
// 	Database string `yaml:"database"`
// 	UserName string `yaml:"user"`
// 	Password string `yaml:"password"`
// }
