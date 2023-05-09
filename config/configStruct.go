package config

type Config struct {
	App     App     `yaml:"app"`
	Polygon Polygon `yaml:"polygon"`
}

type App struct {
	Host string `yaml:"host"`
	Port int    `yaml:"port"`
}

type Polygon struct {
	Url string `yaml:"url"`
}
